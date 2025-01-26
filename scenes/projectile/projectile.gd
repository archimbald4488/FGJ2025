extends Area2D

var speed = 500.0

func _physics_process(delta):
	position += transform.x * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	print("Hit")
	queue_free()
