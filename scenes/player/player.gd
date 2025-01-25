extends CharacterBody2D

@export var speed = 400
@export var health: int
@export var damage: int


func _ready():
	print("Start")

	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	rotation = velocity.angle()
	if Input.is_action_just_pressed("attack"):
		$Attack.play("attack")
		print("attack")

func _physics_process(delta):
	get_input()
	move_and_slide()
	

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.health -= damage
		print(body.health)
		if body.health <= 0:
			print("enemy died")
			body.queue_free()
		
