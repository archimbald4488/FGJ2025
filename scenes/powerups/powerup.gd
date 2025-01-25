extends Area2D

#Check when player is in powerup hitbox
func _on_body_entered(body: Node2D) -> void:
	#Randomly assign powerup type on pickup
	var rng = randi_range(1, 4)
	if rng == 1:
		print("You got sex")
	if rng == 2:
		print("+1000 aura")
	if rng == 3:
		print("+1 megis")
	if rng == 4:
		print("k")
	queue_free()
	
func _on_pow_despawn_timeout() -> void:
	queue_free()
