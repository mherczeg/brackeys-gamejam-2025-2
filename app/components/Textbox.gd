class_name Textbox
extends Label

signal display_complete

const ESTIMATED_LINE_HEIGH: int = 19

@export var estimated_line_char_length: int = 40
var letter_index: int = 0
var display_time: float = 0.02
var text_to_display: String = ""
var is_active_for_interaction: bool = false
var fast_forward: bool = false

@onready var display_timer: Timer = $DisplayTimer

func _ready() -> void:
	display_timer.timeout.connect(_display_letter)

func clear_text() -> void:
	display_timer.stop()
	text = ""

func prepare_size_for_text(new_text: String) -> void:
	var lines: int = ceil(float(new_text.length()) / estimated_line_char_length)
	custom_minimum_size.y = max(0, lines) * ESTIMATED_LINE_HEIGH
	show()

func display_text(new_text: String) -> Signal:
	text_to_display = new_text
	letter_index = 0

	# start with timer instead of calling the function to sequence boxes
	display_timer.start(display_time)

	return display_complete

func _display_letter() -> void:
	if fast_forward:
		display_timer.stop()
		text = text_to_display
		fast_forward = false
		display_complete.emit()
		return

	if letter_index >= text_to_display.length():
		is_active_for_interaction = false
		display_complete.emit()
		return

	text += text_to_display[letter_index]
	letter_index += 1
	display_timer.start(display_time)
