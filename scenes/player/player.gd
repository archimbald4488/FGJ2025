extends CharacterBody2D

signal player_died

const IFRAME_TIME = 1.0

@export var speed: int
@export var health: int
@export var damage: int
@export var accel = 5000
@export var friction = 500
var input = Vector2.ZERO
var is_ready = false
var angle: float
var is_iframe_active = false

const START_JINGLE_DURATION = 1.8
const END_JINGLE_DURATION = 6.9  # nice

func _ready():
	print("Start")
	

func start():
	_handle_music_on_start()
	is_ready = true
	is_iframe_active = false


func _handle_music_on_start():
	$MenuMusic.stop()
	$GameStartJingle.play()
	var timer = Timer.new()
	timer.wait_time = START_JINGLE_DURATION
	timer.one_shot = true
	timer.connect("timeout", Callable($GameMusic, "play"))
	add_child(timer)
	timer.start()

	
func get_input():
	#Movement inputs
	input.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	#Look at mouse direction
	look_at(get_global_mouse_position())
	#angle = get_angle_to(get_global_mouse_position())
	if Input.is_action_just_pressed("attack"):
		$AttackNew.play("AttackNew")
		$Sprite2D.play("Attack animation")
		print("attack")
		#fire()
	return input.normalized()


func game_over():
	is_ready = false
	_handle_music_on_stop()


func _handle_music_on_stop():
	$GameMusic.stop()
	$GameEndJingle.play()
	var timer = Timer.new()
	timer.wait_time = END_JINGLE_DURATION
	timer.one_shot = true
	timer.connect("timeout", Callable($MenuMusic, "play"))
	add_child(timer)
	timer.start()


func _physics_process(delta):
	if not is_ready:
		return
	input = get_input()
	#Movement
	if input == Vector2.ZERO:
		if velocity.length() + (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(speed)
	move_and_slide()
	$Camera2D/HUD.update_damage(damage)
	
	# Check if any collisions occurred
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)

		var collided_object = collision.get_collider()
		if collided_object and collided_object.is_in_group("Enemy") and not is_iframe_active:
			print("Collided with an enemy!")
			health -= 1
			$Camera2D/HUD.update_health(health)
			if health <= 0:
				print("player died.")
				game_over()
				emit_signal("player_died")
			else: 
				is_iframe_active = true
				var timer = Timer.new()
				timer.wait_time = IFRAME_TIME
				timer.one_shot = true
				timer.timeout.connect(_deactivate_iframes)
				add_child(timer)
				timer.start()
				

func _deactivate_iframes():
	is_iframe_active = false

	
#Check if enemy is in attack hitbox and deal damage
func _on_attack_body_entered(body: Node2D) -> void:
	print("Body entered:", body)
	if body.is_in_group("Enemy"):
		body.take_damage(damage)


func _on_attack_new_animation_finished(anim_name: StringName) -> void:
	$Sprite2D.play("Idle animation")
