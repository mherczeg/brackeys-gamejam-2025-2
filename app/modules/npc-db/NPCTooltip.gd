class_name NPCTooltip
extends Control

@onready var npc_info_box: NPCInfoBox = %NPCInfoBox

func _ready() -> void:
	EventBus.ui.show_npc_info.connect(_on_show_npc_info)
	EventBus.ui.hide_npc_info.connect(_on_hide_npc_info)

func _on_show_npc_info(new_npc: NPC, new_position: Vector2) -> void:
	if visible && new_npc == npc_info_box.npc:
		return

	npc_info_box.set_npc(new_npc)
	position = _get_position_restricted_to_viewport(new_position)
	show()

func _on_hide_npc_info() -> void:
	hide()

func _get_position_restricted_to_viewport(new_position: Vector2) -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size

	return Vector2(
		min(viewport_size.x - npc_info_box.size.x, new_position.x),
		min(viewport_size.y - npc_info_box.size.y, new_position.y)
	)