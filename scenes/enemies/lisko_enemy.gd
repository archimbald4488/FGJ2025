extends CharacterBody2D
var movement_speed: float = 180.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

# Health
@export var health: int = 2
@export var damage: int
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D



func _ready() -> void:
	set_physics_process(false)
	call_deferred("wait_for_physics")

func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() and target_to_chase.global_position == navigation_agent.target_position:
		return
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * movement_speed
	move_and_slide()
