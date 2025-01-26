extends "res://scenes/enemies/enemy_base/enemy_base.gd"

@export var bounce_height: float = 50.0  # Maximum height of the bounce
@export var bounce_speed: float = 3.0   # Speed of the bounce

var bounce_offset: float = 0.0  # Keeps track of the bounce offset

func _ready() -> void:
	super._ready()
	bounce_offset = global_position.y  # Set the starting Y position

func _physics_process(delta: float) -> void:
	# Call the base movement logic for chasing
	super._physics_process(delta)

	# Add bouncing behavior
	var time_in_seconds = Time.get_ticks_msec() / 1000.0
	var bounce_y = sin(time_in_seconds * bounce_speed) * bounce_height
	global_position.y = bounce_offset + bounce_y
