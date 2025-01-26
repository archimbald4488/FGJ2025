extends CanvasLayer

signal start_game

@onready var start_menu = $StartMenu
@onready var in_game_hud = $InGameHUD
@onready var health_bar = $InGameHUD/HealthBar
@onready var damage_text = $InGameHUD/DamageText
@onready var pause_button = $InGameHUD/PauseButton
@onready var timer = $Timer

var score: int = 0  # Player's score

# Initialize the HUD
func _ready() -> void:
	# Show the main menu by default
	start_menu.visible = true
	in_game_hud.visible = false
	$ScoreLabel.text = "Score: 0"  # Initialize score display

# Small temporary message
func small_message(text: String, time: float) -> void:
	$SmallMessage.text = text
	$SmallMessage.show()
	if time > 0:
		timer.wait_time = time
		timer.start()

# Big temporary message
func big_message(text: String, time: float) -> void:
	$BigMessage.text = text
	$BigMessage.show()
	if time > 0:
		timer.wait_time = time
		timer.start()

# Update health display
func update_health(value: float) -> void:
	health_bar.value = value

# Update damage display
func update_damage(value: int) -> void:
	damage_text.text = "Your damage: " + str(value)
	
func update_score(value: int) -> void:
	if value != 0:
		score += value
		$ScoreLabel.text = "Your score: " + str(score)
	else:
		score = 0
		$ScoreLabel.text = "Your score: 0"
	
# Show game over message
func show_game_over() -> void:
	big_message("Game Over", 2)
	await timer.timeout
	#big_message("Brew the brew", 0)
	start_menu.visible = true
	in_game_hud.visible = false

# Start button pressed
func _on_start_button_pressed() -> void:
	start_menu.visible = false
	in_game_hud.visible = true
	emit_signal("start_game")

# Pause button pressed
func _on_pause_button_pressed() -> void:
	# Toggle the pause state
	print("Pause button pressed")
	if get_tree().paused:
		get_tree().paused = false  # Unpause the game
		pause_button.text = "Pause"  # Change button text back to "Pause"
	else:
		get_tree().paused = true  # Pause the game
		pause_button.text = "Resume"  # Change button text to "Resume"
		
func _on_timer_timeout():
	$BigMessage.hide()
	$SmallMessage.hide()
