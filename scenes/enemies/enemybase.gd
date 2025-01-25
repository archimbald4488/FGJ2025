# enemy-base.gddd
extends CharacterBody2D
class_name EnemyBase

var health: Health
var movement: Movement

@onready var navigation: NavigationAgent2D = $NavigationAgent2D
@export var chase_target: CharacterBody2D
@export var max_health: int = 100
@export var max_speed: int = 180
@export var damage: int = 1


func _init():
	add_to_group("Enemy")
	self.health = Health.from_args(max_health)
	self.health.health_changed.connect(_health_changed)
	self.health.dead.connect(_dead)
	self.movement = Movement.from_args(max_speed, 30, 0.1)

func _ready() -> void:
	set_physics_process(false)
	call_deferred("wait_for_physics")

func wait_for_physics() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta:float) -> void:
	if navigation.is_navigation_finished() and chase_target.position == navigation.target_position:
		return
	navigation.target_position = chase_target.position
	var next_position = position.direction_to(navigation.get_next_path_position())
	velocity = movement.update_movement(next_position, delta)
	rotation = velocity.angle()
	move_and_slide()

func _health_changed(new_health: int):
	print("Health %s." % new_health)

func _dead():
	print("Dead")
	Camera2D/HUD.update_score(1)
	queue_free()

func take_damage(amount: int):
	health.take_damage(amount)

func heal(amount: int):
	health.heal(amount)


func deal_damage(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(self.damage)		
