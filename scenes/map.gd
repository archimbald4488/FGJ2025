extends Node2D

@onready var cauldron = $Cauldron  # Reference to the cauldron node
@onready var player = $Player  # Reference to the player node
@onready var camera = $Player/Camera2D  # Reference to the camera node
@onready var hud = $Player/Camera2D/HUD
@onready var enemy = $LiskoEnemy
var enemy_hp: int = 2

@export var spawn_interval: float = 3.0  # Time in seconds between spawns
@export var min_spawn_distance: float = 100.0  # Minimum distance from the player for spawn
@export var bubble_scene_path: String = "res://scenes/bubble.tscn"  # Path to the bubble scene
@export var enemy_scene_path: String = "res://scenes/enemies/lisko_enemy.tscn"  # Path to the enemy scene
@export var powerup_scene_path: String = "res://scenes/powerups/powerup.tscn"  # Path to the enemy scene

func _ready():
	#new_game()
	$Player.hide()
	hud.connect("start_game", Callable(self, "_on_start_game"))

func new_game():
	get_tree().call_group("Enemy", "queue_free")
	$Player.position = $StartPosition.position
	$Cauldron.camera = $Player/Camera2D
	$Cauldron.player = $Player
	$Player.show()
	$Player.health = 10
	$Player/Camera2D/HUD.update_health(10)
	$Player/Camera2D/HUD.update_damage(1)
	$Player.start()
	$Cauldron.start_spawning()
	$Difficulty.start()


func start_spawning():
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(timer)
	timer.start()
	
	

# Called each time the timer triggers
func _on_spawn_timer_timeout():
	spawn_enemy_with_bubble()

# Main function to handle spawning logic
func spawn_enemy_with_bubble():
	# Get a random spawn position within the camera's view
	var spawn_position = get_random_spawn_position(player.global_position, min_spawn_distance)

	# Animate the bubble from the cauldron to the spawn position
	animate_bubble(cauldron.global_position, spawn_position)

	# Delay to match bubble animation timing
	await get_tree().create_timer(1.0).timeout

	# Spawn the enemy and powerups at the calculated position
	var rng = randi_range(1, 2)
	print(rng)
	if rng == 1:
		spawn_enemy_at_position(spawn_position)
	elif rng == 2:
		spawn_powerup_at_position(spawn_position)
	else:
		print("Failed to load enemy")

# Animate a bubble moving from the cauldron to the target position
func animate_bubble(cauldron_position: Vector2, target_position: Vector2):
	var bubble_scene = preload("res://scenes/bubble.tscn")
	var bubble = bubble_scene.instantiate()
	bubble.scale = Vector2(0.1, 0.1)
	add_child(bubble)

	# Start the bubble animation
	bubble.start_animation(cauldron_position, target_position)

# Calculate a random position within the camera's view and far enough from the player
func get_random_spawn_position(player_position: Vector2, min_distance: float) -> Vector2:
	# Calculate the visible area of the camera
	var viewport_size = get_viewport().get_visible_rect().size
	var half_viewport = viewport_size * 0.5 * camera.zoom
	var camera_rect = Rect2(camera.global_position - half_viewport, viewport_size * camera.zoom)

	var spawn_position = Vector2.ZERO

	# Ensure the position is sufficiently far from the player
	while true:
		spawn_position.x = randf_range(camera_rect.position.x, camera_rect.position.x + camera_rect.size.x)
		spawn_position.y = randf_range(camera_rect.position.y, camera_rect.position.y + camera_rect.size.y)

		if spawn_position.distance_to(player_position) > min_distance:
			break

	return spawn_position

# Spawn powerup at the specified position
func spawn_powerup_at_position(position: Vector2):
	print("Powerup spawned at: ", position)
	var powerup_scene = preload("res://scenes/powerups/powerup.tscn")
	var powerup = powerup_scene.instantiate()
	powerup.position = position
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

	enemy.target_to_chase = $Player
	enemy.scale = Vector2(0.1, 0.1)
	add_child(enemy)


func _on_difficulty_timeout() -> void:
	print("Difficulty increased!")
	
