extends AnimatedSprite2D

@export var target_position: Vector2  # Target position where the bubble will move
@export var animation_time: float = 1.0  # Time for the bubble to reach the target position
@export var bubble_animation: String = "bubbles"  # Name of the animation

var start_position: Vector2  # Cauldron's position
var control_position: Vector2  # Control point to define the curve
var time_elapsed: float = 0.0  # Time elapsed during the animation

func start_animation(from_position: Vector2, to_position: Vector2, duration: float):
	start_position = from_position
	target_position = to_position
	animation_time = duration

	# Calculate the control point (midway between start and target, and above for a curve)
	control_position = (start_position + target_position) / 2
	control_position.y -= 100  # Adjust the curve height

	time_elapsed = 0.0
	global_position = start_position
	play(bubble_animation)

func _process(delta: float):
	if time_elapsed < animation_time:
		time_elapsed += delta
		var t = time_elapsed / animation_time
		global_position = bezier_curve(start_position, control_position, target_position, t)
	else:
		queue_free()

func bezier_curve(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var u = 1.0 - t
	return u * u * p0 + 2 * u * t * p1 + t * t * p2
