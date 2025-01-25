# Health.gd
class Health:
	# Signals
	signal health_changed(new_health)
	signal dead()

	# Variables

	@export var max_health: int = 100
	var current_health: int = 100

	# Funcs

	func _init():
		self.current_health = max_health

	# Public Methods
	func take_damage(amount: int):
		current_health -= amount
		if current_health < 0:
			current_health = 0
		emit_signal("health_changed", current_health)
		if current_health == 0:
			emit_signal("dead")

	func heal(amount: int):
		current_health += amount
		if current_health > max_health:
			current_health = max_health
		emit_signal("health_changed", current_health)

	func is_dead() -> bool:
		return current_health <= 0

	func reset_health():
		current_health = max_health
		emit_signal("health_changed", current_health)
