extends Node2D

@export var spawn_interval = 5.0
@export var enemy_percentage = 0.8
@export var camera: Camera2D
@export var player: CharacterBody2D
var timer: Timer
const SPAWN_MAX_RADIUS = 320
const SPAWN_MIN_RADIUS = 130

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_spawning():
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(timer)
	timer.start()
	player.player_died.connect(stop_spawning)

func stop_spawning():
	timer.stop()
	get_tree().call_group("Enemy", "queue_free")
	

# Called each time the timer triggers
func _on_spawn_timer_timeout():
	spawn_enemy_with_bubble()

# Main function to handle spawning logic
func spawn_enemy_with_bubble():
	# Get a random spawn position within the camera's view
	var spawn_position = get_random_spawn_position(player.global_position)

	# Animate the bubble from the cauldron to the spawn position
	animate_bubble(spawn_position)

	# Delay to match bubble animation timing
	await get_tree().create_timer(1.0).timeout

	# Spawn the enemy and powerups at the calculated position
	var rng = randf()
	if rng < enemy_percentage:
		spawn_enemy_at_position(spawn_position)
	else:
		spawn_powerup_at_position(spawn_position)

# Animate a bubble moving from the cauldron to the target position
func animate_bubble(target_position: Vector2):
	var bubble_scene = preload("res://scenes/bubble.tscn")
	var bubble = bubble_scene.instantiate()
	bubble.scale = Vector2(0.15, 0.15)
	add_child(bubble)

	# Start the bubble animation
	bubble.start_animation(self.global_position, target_position)

# Calculate a random position within the camera's view and far enough from the player
func get_random_spawn_position(player_position: Vector2) -> Vector2:
	var self_to_player = player_position - self.global_position
	var random_angle_change = (randf() * 2) - 1
	var spawn_vector_length = randi_range(SPAWN_MIN_RADIUS, SPAWN_MAX_RADIUS)
	
	return self_to_player.normalized().rotated(random_angle_change) * spawn_vector_length

# Spawn powerup at the specified position
func spawn_powerup_at_position(position: Vector2):
	print("Powerup spawned at: ", position)
	var powerup_scene = preload("res://scenes/powerups/powerup.tscn")
	var powerup = powerup_scene.instantiate()
	powerup.position = position
	powerup.scale = Vector2(0.15, 0.15)
	add_child(powerup)
	

# Spawn an enemy at the specified position
func spawn_enemy_at_position(position: Vector2):
	print("Enemy spawned at: ", position)
	var enemy_scene = preload("res://scenes/enemies/lisko_enemy.tscn")
	var enemy = enemy_scene.instantiate()
	enemy.position = position
	enemy.add_to_group("Enemy", true)
	# Connect the body_entered signal to the _on_attack_body_entered method
	var collision = enemy.get_node("CollisionShape2D")  # Assuming your collision node is named "CollisionShape2D"
	collision.connect("body_entered", Callable(player, "_on_attack_body_entered"))

	enemy.target_to_chase = player
	enemy.scale = Vector2(0.07, 0.07)
	add_child(enemy)
