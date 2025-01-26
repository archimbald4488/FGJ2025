extends "res://scenes/enemies/enemy_base/enemy_base.gd"

@export var fireball_cooldown: float = 2.0  # Cooldown time between fireball spits

var fireball_timer: Timer

func _ready() -> void:
	super._ready()
	# Initialize the fireball timer
	fireball_timer = Timer.new()
	fireball_timer.one_shot = true
	fireball_timer.connect("timeout", self._spit_fireball)
	add_child(fireball_timer)
	fireball_timer.start(_get_next_spit_time())

func _get_next_spit_time() -> float:
	return fireball_cooldown + randf()

func _spit_fireball() -> void:
	fireball_timer.start(_get_next_spit_time())
	if not is_instance_valid(chase_target):
		return  # Ensure the target exists
	var fireball_scene = preload("res://scenes/enemies/fireball.tscn")
	var fireball = fireball_scene.instantiate()

	# Set the fireball's position to the salamander's current global position
	fireball.global_position = global_position

	# Rotate the fireball to face the target
	fireball.rotation = (chase_target.global_position - global_position).angle()

	# Add the fireball as a child of the parent node (not the enemy itself)
	get_parent().add_child(fireball)
