extends Area2D
signal powerup
#Check when player is in powerup hitbox
func _on_body_entered(body: Node2D) -> void:
	
	if body.name != "Player":
		return 

	#Randomly assign powerup type on pickup
	var rng = randi_range(1,4)
	if rng == 1:
		body.speed += 20
		body.display_message("Speed up!")
	if rng == 2:
		body.damage += 1
		body.display_message("Damage up!")
	if rng == 3:
		body.health += 1
		body.display_message("Health potion!")
	if rng == 4:
		body.display_message("You get nothing!")
	queue_free()
	
func _on_pow_despawn_timeout() -> void:
	queue_free()
