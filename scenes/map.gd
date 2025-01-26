extends Node2D

@onready var cauldron = $Cauldron  # Reference to the cauldron node
@onready var player = $Player  # Reference to the player node
@onready var camera = $Player/Camera2D  # Reference to the camera node
@onready var hud = $Player/Camera2D/HUD
#@onready var enemy = $LiskoEnemy
@onready var enemy_hp: int = 2

@export var spawn_interval: float = 3.0  # Time in seconds between spawns
@export var min_spawn_distance: float = 100.0  # Minimum distance from the player for spawn
@export var bubble_scene_path: String = "res://scenes/bubble.tscn"  # Path to the bubble scene
@export var enemy_scene_path: String = "res://scenes/enemies/lisko_enemy.tscn"  # Path to the enemy scene
@export var powerup_scene_path: String = "res://scenes/powerups/powerup.tscn"  # Path to the enemy scene

func _ready():
	#new_game()
	$Player.hide()
	hud.connect("start_game", Callable(self, "_on_start_game"))

func new_game():
	get_tree().call_group("Enemy", "queue_free")
	$Player.position = $StartPosition.position
	$Cauldron.camera = $Player/Camera2D
	$Cauldron.player = $Player
	$Player.hud = $Player/Camera2D/HUD
	$Player.show()
	$Player.start()
	$Cauldron.start_spawning()
