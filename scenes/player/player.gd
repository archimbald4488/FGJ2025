extends CharacterBody2D

@export var speed = 400

func _ready() -> void:
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


func _on_attack_area_entered(area: Area2D) -> void:
	print("Suicide")
