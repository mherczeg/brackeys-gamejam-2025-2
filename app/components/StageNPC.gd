@tool
class_name StageNPC
extends TextureRect


@onready var textbox: Textbox = $Text


func clear_text() -> void:
	textbox.clear_text()
	textbox.hide()

func set_text(text: String) -> Signal:
	if !text:
		textbox.hide()
	else:
		textbox.show()

	return textbox.display_text(text)


func _get_configuration_warnings() -> PackedStringArray:
	var lbl: Textbox = get_node_or_null("Text")
	if lbl == null:
		return ["StageNPC expects a child Label named 'Text'. Add a Textbox node as a direct child."]
	if not lbl is Textbox:
		return ["Child node 'Text' is present but is not a Textbox. Make it a Textbox."]
	return []
