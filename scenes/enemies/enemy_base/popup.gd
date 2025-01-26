# EnemyPopup.gd
extends Control
class_name EnemyPopup

# Signals
signal popup_opened()
signal popup_closed()

# Variables
var text: String = "Enemy Spotted!"
var duration: float = 3.0  # Time in seconds before the popup disappears
var is_visible: bool = false
var offset: Vector2 = Vector2(0, 0)  # Offset above the enemy position
var funny_arr_messages: Array = [
	"What NO MONEY!?!",
	"You will die!",
	"Die, you rebel scum!",
	"Uli uli uuu!",
	"Arr",
	"Kill the keittokeisartti!",
	"Kymmeneskortti juodaan tuplana.",
	"messages[randi() % messages.size()])",
	"FGJ2025",
	"Arrr!",
	"Mököarttii!",
	"For the Great Sourcerer Artti!",
	"Feed us",
	"Missä on Tuomas?",
	"You never get Thomas from the black hand",
	"10 of spades"
]

# Nodes
@onready var label: Label = $Panel/Label

func _ready():
	# Hide popup initially
	visible = false

# Public Methods
func show_popup(new_text: String = "", custom_duration: float = 0.0):
	if new_text != "":
		text = new_text
	if custom_duration > 0.0:
		duration = custom_duration

	label.text = text
	visible = true
	is_visible = true
	emit_signal("popup_opened")

	# Hide after a delay
	await get_tree().create_timer(duration).timeout
	hide_popup()

func show_random_message(custom_duration: float = 0.0):
	# Pick a random message from the list
	var random_message = funny_arr_messages[randi() % funny_arr_messages.size()]
	show_popup(random_message, custom_duration)

func hide_popup():
	visible = false
	is_visible = false
	emit_signal("popup_closed")

# Called every frame to adjust position based on the parent
func _process(delta):
	if get_parent():
		position = get_parent().position + offset
