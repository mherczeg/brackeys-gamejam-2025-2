class_name StageNPC
extends TextureRect

@export var textbox: Textbox

func _ready() -> void:
	EventBus.customer.fast_forward.connect(fast_forward_display_text)

func activate_for_interaction() -> void:
	show()
	textbox.is_active_for_interaction = true

func clear_interaction() -> void:
	textbox.is_active_for_interaction = false
	textbox.fast_forward = false

func clear_text() -> void:
	textbox.clear_text()
	textbox.hide()

func display_text(text: String) -> Signal:
	if !text:
		textbox.hide()
	else:
		textbox.show()

	return textbox.display_text(text)

func fast_forward_display_text() -> void:
	if textbox.is_active_for_interaction:
		textbox.fast_forward = true
