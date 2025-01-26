# Health.gd
extends Object
class_name Health

# Signals
signal health_changed(new_health)
signal dead()

# Variables

var max_health: int
var current_health: int

# Funcs

static func from_args(max_health: int = 1) -> Health:
	var health = Health.new()
	health.max_health = max_health
	health.current_health = max_health
	return health

# Public Methods
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0
	health_changed.emit(current_health)
	if current_health == 0:
		dead.emit()

func heal(amount: int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	health_changed.emit(current_health)

func is_dead() -> bool:
	return current_health <= 0

func reset_health() -> void:
	current_health = max_health
	health_changed.emit(current_health)
