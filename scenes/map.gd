extends Node2D

@onready var cauldron = $Cauldron  # Reference to the cauldron scene
@export var spawn_interval: float = 3.0  # Time in seconds between spawns

func _ready():
	# Example of spawning an enemy with a bubble after 3 seconds
	await get_tree().create_timer(3.0).timeout  # Wait 3 seconds
	await spawn_enemy_with_bubble($Camera2D, $Player.position, $Cauldron.position, 100)


# This function can be used to spawn an enemy and animate the bubble
func spawn_enemy_with_bubble(camera: Camera2D, player_position: Vector2, cauldron_position: Vector2, min_distance: float): #camera: Camera2D
	# Get a random spawn position within the camera's view, ensuring it's not too close to the player
	var spawn_position = get_random_spawn_position(camera, player_position, min_distance)

	# Animate the bubble from the cauldron to the spawn position
	animate_bubble(cauldron_position, spawn_position)

	# Delay the enemy spawn slightly to match the animation timing
	await get_tree().create_timer(1.0).timeout  # Wait for 1 second before spawning the enemy

	# Now spawn the enemy at the spawn position
	spawn_enemy_at_position(spawn_position)

# This function triggers the bubble movement
func animate_bubble(cauldron_position: Vector2, target_position: Vector2):
	var bubble_scene = preload("res://scenes/bubble.tscn")  # Path to your bubble scene
	var bubble = bubble_scene.instantiate()
	add_child(bubble)

	# Start the bubble animation from the cauldron to the target position
	bubble.start_animation(cauldron_position, target_position)

# This function calculates a random spawn position within the camera's view and ensures it's not too close to the player
func get_random_spawn_position(camera: Camera2D, player_position: Vector2, min_distance: float) -> Vector2:
	var camera_rect = camera.get_camera_rect()  # Get the visible area of the camera
	var spawn_position = Vector2.ZERO

	# Keep generating random positions until one is sufficiently far from the player
	while true:
		spawn_position.x = randf_range(camera_rect.position.x, camera_rect.position.x + camera_rect.size.x)
		spawn_position.y = randf_range(camera_rect.position.y, camera_rect.position.y + camera_rect.size.y)

		# Ensure the spawn position is not too close to the player
		if spawn_position.distance_to(player_position) > min_distance:
			break

	return spawn_position

# This function spawns an enemy at the specified position
func spawn_enemy_at_position(position: Vector2):
	print("Enemy spawned at: ", position)
	var enemy_scene = preload("res://scenes/enemies/lisko_enemy.tscn")
	var enemy = enemy_scene.instantiate()
	enemy.position = position
	add_child(enemy)
