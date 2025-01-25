extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func small_message(text, time):
	$SmallMessage.text = text
	$SmallMessage.show()
	if time != 0:
		$Timer.wait_time = time
		$Timer.start()
	
func big_message(text, time):
	$BigMessage.text = text
	$BigMessage.show()
	if time != 0:
		$Timer.wait_time = time
		$Timer.start()

func hp_text(text):
	$Health.text = text
	$Health.show()
	
func dmg_text(text):
	$Damage.text = text
	$Damage.show()
	
func show_game_over():
	big_message("Game Over", 2)
	await $Timer.timeout
	big_message("Brew the brew", 0)
	$StartButton.show()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_timer_timeout() -> void:
	$BigMessage.hide()
	$SmallMessage.hide()
