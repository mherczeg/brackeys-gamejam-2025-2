@tool
class_name StageNPC
extends TextureRect

@onready var textbox: Textbox = $Text

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

func _get_configuration_warnings() -> PackedStringArray:
	var lbl: Textbox = get_node_or_null("Text")
	if lbl == null:
		return ["StageNPC expects a child Label named 'Text'. Add a Textbox node as a direct child."]
	if not lbl is Textbox:
		return ["Child node 'Text' is present but is not a Textbox. Make it a Textbox."]
	return []
