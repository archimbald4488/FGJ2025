# Movement.gd
extends Object
class_name Movement

# Current Variables
var current_vector: Vector2 = Vector2.ZERO
var current_speed: float = 0

# Consts
@export var max_speed: float = 180
@export var acceleration: float = 30
@export var friction: float = 0.1

static func from_args(max_speed:float, acceleration:float, friction: float) -> Movement:
	var movement = Movement.new()
	movement.max_speed = max_speed
	movement.acceleration = acceleration
	movement.friction = friction
	return movement

func _update_direction(target_direction: Vector2, delta:float):
	var new_direction = self.current_vector.lerp(target_direction, friction * delta)
	return new_direction.normalized();

func _update_speed(delta:float) -> float:
	var new_speed = self.current_speed + self.acceleration
	if new_speed > self.max_speed:
		new_speed = self.max_speed

	return new_speed * delta

# Public Methods
func update_movement(new_direction: Vector2, delta: float) -> Vector2:
	var speed = _update_speed(delta)
	var direction = _update_direction(new_direction, delta)
	return direction * speed
