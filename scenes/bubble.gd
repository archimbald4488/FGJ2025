extends AnimatedSprite2D

@export var target_position: Vector2  # Target position where the bubble will move
@export var animation_time: float = 1.0  # Time for the bubble to reach the target position
@export var bubble_animation: String = "bubbles"  # Name of the animation (adjust to your sprite's animation)

var start_position: Vector2  # Cauldron's position
var control_position: Vector2  # Control point to define the curve
var time_elapsed: float = 0.0  # Time elapsed during the animation

func _ready():
	# Set initial position and target
	start_position = global_position  # This should be the cauldron's position
	play(bubble_animation)  # Play the bubble's floating animation (adjust this as needed)

func start_animation(from_position: Vector2, to_position: Vector2):
	start_position = from_position
	target_position = to_position

	# Calculate the control point (midway between start and target, and above for a curve)
	control_position = (start_position + target_position) / 2
	control_position.y -= 100  # Adjust the curve height

	# Reset time elapsed
	time_elapsed = 0.0

func _process(delta: float):
	# If the bubble hasn't finished moving, continue animating
	if time_elapsed < animation_time:
		time_elapsed += delta

		# Calculate the interpolation factor (0 to 1 over time)
		var t = time_elapsed / animation_time

		# Calculate the current position along the Bezier curve using quadratic interpolation
		var current_position = bezier_curve(start_position, control_position, target_position, t)

		# Move the bubble to the new position
		global_position = current_position
	else:
		# Once the animation is finished, remove the bubble
		queue_free()

# Quadratic Bezier curve interpolation function
func bezier_curve(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var u = 1.0 - t
	var tt = t * t
	var uu = u * u

	var p = uu * p0  # First term
	p += 2 * u * t * p1  # Second term
	p += tt * p2  # Third term

	return p
