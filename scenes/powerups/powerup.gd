extends Area2D
signal powerup
#Check when player is in powerup hitbox
func _on_body_entered(body: Node2D) -> void:
	powerup.emit()
	if body.name == "Player":
		#Randomly assign powerup type on pickup
		var rng = randi_range(1, 3)
		if rng == 1:
			body.speed += 20
			print("Speed up!")
		if rng == 2:
			body.damage += 1
			print("Damage up!")
		if rng == 3:
			body.health += 1
			print("Health potion!")
	queue_free()
	
func _on_pow_despawn_timeout() -> void:
	queue_free()
