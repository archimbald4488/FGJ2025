extends RigidBody2D

@export var speed: float = 300.0  # Fireball speed
@export var damage: int = 1    # Damage dealt by the fireball
@export var lifetime: float = 2.0  # Time (in seconds) before the fireball disappears


func _ready() -> void:
	# Apply an initial impulse to make the fireball move
	apply_central_impulse(Vector2(speed, 0).rotated(rotation))
	
	# Add a timer to control the fireball's lifetime
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", self._on_lifetime_timeout)
	add_child(timer)
	timer.start()

func _on_lifetime_timeout() -> void:
	queue_free()  # Remove the fireball when its lifetime ends

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  # Destroy the fireball on impact
