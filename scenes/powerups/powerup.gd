extends Area2D
signal powerup

const POWERUP_WEIGHTS = {
	"speed": 4,
	"damage": 8,
	"health": 2,
	"nothing": 1
}
const POWERUP_CONFIG = {
	"speed": {
		"speed_increase": 15,
		"friction_increase": 30
	},
	"damage": {
		"damage_increase": 1
	},
	"health": {
		"health_returned": 1
	}
}

func _sum(list: Array) -> int:
	var sum = 0
	for item in list:
		sum += item
	return sum

func _get_random_powerup() -> String:
	var max = _sum(POWERUP_WEIGHTS.values())
	var rng = randi_range(1, max)
	for key in POWERUP_WEIGHTS:
		rng -= POWERUP_WEIGHTS[key]
		if rng <= 0:
			return key
	return "nothing"
		

#Check when player is in powerup hitbox
func _on_body_entered(body: Node2D) -> void:
	
	if body.name != "Player":
		return 

	#Randomly assign powerup type on pickup
	var powerup = _get_random_powerup()
	if powerup == "speed":
		body.speed += POWERUP_CONFIG["speed"]["speed_increase"]
		body.friction += POWERUP_CONFIG["speed"]["friction_increase"]
		body.display_message("Speed up!")
	elif powerup == "damage":
		body.damage += POWERUP_CONFIG["damage"]["damage_increase"]
		body.display_message("Damage up!")
	elif powerup == "health":
		body.health += POWERUP_CONFIG["health"]["health_returned"]
		body.display_message("Health potion!")
	else:
		body.display_message("You get nothing!")
	queue_free()
	
func _on_pow_despawn_timeout() -> void:
	queue_free()
