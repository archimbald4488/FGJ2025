# enemy-base.gd
extends CharacterBody2D

var health: Health
var movement: Movement
var navigation: NavigationAgent2D

@onready var on_hit_sound_effect: AudioStreamPlayer2D = $EnemyHit
@export var hud: CanvasLayer
@export var chase_target: CharacterBody2D
@export var max_health: int
@export var max_speed: int
@export var damage: int

func _init_health(max_health:int):
	self.health = Health.from_args(max_health)
	self.health.health_changed.connect(_health_changed)
	self.health.dead.connect(_dead)

func _init_movement(max_speed:int):
	self.movement = Movement.from_args(max_speed, 90, 0.1)
	navigation = $NavigationAgent2D


func _ready() -> void:
	add_to_group("Enemy", true)
	self._init_health(max_health)
	self._init_movement(max_speed)
	set_physics_process(false)
	call_deferred("wait_for_physics")


func wait_for_physics() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta:float) -> void:
	if navigation.is_navigation_finished() and chase_target.global_position == navigation.target_position:
		return
		
	navigation.target_position = chase_target.global_position
	#var next_position = global_position.direction_to(navigation.get_next_path_position())
	#var new_velocity = movement.update_movement(next_position, delta)
	velocity = global_position.direction_to(navigation.get_next_path_position()) * movement.max_speed
	#velocity = new_velocity
	rotation = velocity.angle()
	move_and_slide()

func _health_changed(new_health: int):
	print("Health %s." % new_health)

func _dead():
	print("Dead")
	hud.update_score(1)
	queue_free()

func take_damage(amount: int):
	on_hit_sound_effect.play()
	health.take_damage(amount)

func heal(amount: int):
	health.heal(amount)


func deal_damage(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(self.damage)		
