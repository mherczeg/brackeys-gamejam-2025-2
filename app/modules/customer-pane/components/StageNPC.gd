class_name StageNPC
extends TextureRect

const TOOLTIP_OFFSET: Vector2 = Vector2(32, 32)

@export var textbox: Textbox

var npc: NPC

func _ready() -> void:
	EventBus.customer.fast_forward.connect(fast_forward_display_text)
	mouse_entered.connect(_on_npc_hover_start)
	mouse_exited.connect(_on_npc_hover_end)

func _on_npc_hover_start() -> void:
	if npc != null:
		EventBus.ui.show_npc_info.emit(npc, get_global_mouse_position() + TOOLTIP_OFFSET)

func _on_npc_hover_end() -> void:
	EventBus.ui.hide_npc_info.emit()

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
