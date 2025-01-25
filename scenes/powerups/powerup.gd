extends Area2D

func _ready() -> void:
	pass
	
#Check when player is in powerup hitbox
func _on_body_entered(body: Node2D) -> void:
	queue_free()
