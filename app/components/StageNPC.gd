@tool
class_name StageNPC
extends TextureRect

signal set_text_complete

@onready var textbox: Textbox = $Text


func set_text(text: String) -> void:
	if !text:
		textbox.clear_text()
		textbox.hide()
		set_text_complete.emit()
	else:
		textbox.show()
		await textbox.display_text(text)
		set_text_complete.emit()


func _get_configuration_warnings() -> PackedStringArray:
	var lbl: Textbox = get_node_or_null("Text")
	if lbl == null:
		return ["StageNPC expects a child Label named 'Text'. Add a Textbox node as a direct child."]
	if not lbl is Textbox:
		return ["Child node 'Text' is present but is not a Textbox. Make it a Textbox."]
	return []
