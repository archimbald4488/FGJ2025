# Movement.gd
extends Object
class_name Movement

# Current Variables
var current_vector: Vector2
var current_speed: float

# Consts
@export var max_speed: float
@export var acceleration: float 
@export var friction: float

static func from_args(max_speed:float, acceleration:float, friction: float) -> Movement:
	var movement = Movement.new()
	movement.max_speed = max_speed
	movement.acceleration = acceleration
	movement.friction = friction
	movement.current_speed = 0
	movement.current_vector = Vector2.ZERO
	return movement

func _update_direction(target_direction: Vector2, delta:float):
	var new_direction = target_direction #self.current_vector.lerp(target_direction)
	return new_direction.normalized();

func _update_speed(delta:float) -> float:
	var new_speed = self.current_speed + self.acceleration
	if new_speed > self.max_speed:
		new_speed = self.max_speed

	return new_speed * delta * friction

# Public Methods
func update_movement(new_direction: Vector2, delta: float) -> Vector2:
	var speed = _update_speed(delta)
	var direction = _update_direction(new_direction, delta)
	return direction * speed
