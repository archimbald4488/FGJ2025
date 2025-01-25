extends CharacterBody2D

@export var speed = 200
@export var health: int
@export var damage: int
@export var accel = 5000
@export var friction = 500
var input = Vector2.ZERO

func _ready():
	print("Start")

	
func get_input():
	#Movement inputs
	input.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	#Look at mouse direction
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("attack"):
		#Play attack animation
		$Attack.play("attack")
		print("attack")
	return input.normalized()
	


func _physics_process(delta):
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
	
#Check if enemy is in attack hitbox and deal damage
func _on_attack_body_entered(body: Node2D) -> void:
	print("Body entered:", body)
	if body.is_in_group("Enemy"):
		print("Hit enemy:", body)
		body.health -= damage
		if body.health <= 0:
			print("enemy died")
			body.queue_free()
		
