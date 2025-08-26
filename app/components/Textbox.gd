class_name Textbox
extends Label

signal display_complete

var letter_index: int = 0
var display_time: float = 0.02
var text_to_display: String = ""

@onready var display_timer: Timer = $DisplayTimer

func _ready() -> void:
	display_timer.timeout.connect(_display_letter)


func clear_text() -> void:
	text = ""


func display_text(new_text: String) -> Signal:
	# text = new_text
	# await resized
	text_to_display = new_text
	letter_index = 0
	_display_letter()
	return display_complete


func _display_letter() -> void:
	text += text_to_display[letter_index]

	letter_index += 1

	if letter_index >= text_to_display.length():
		display_complete.emit()
		return

	display_timer.start(display_time)
