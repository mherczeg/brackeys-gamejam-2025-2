class_name NPCInfoBox
extends PanelContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://components/EffectLabelIcon.tscn")

var npc: NPC

@onready var npc_name: Label = %NPCName
@onready var real_name: Label = %RealName
@onready var npc_icon: TextureRect = %NPCIcon
@onready var liked_effects: HBoxContainer = %LikedEffets
@onready var disliked_effects: HBoxContainer = %DislikedEffects

func _ready() -> void:
	EventBus.ui.show_npc_info.connect(_on_show_npc_info)
	EventBus.ui.hide_npc_info.connect(_on_hide_npc_info)

func _on_show_npc_info(new_npc: NPC, new_position: Vector2) -> void:
	if visible && new_npc == npc:
		return
	npc = new_npc
	_render()
	position = new_position
	show()

func _on_hide_npc_info() -> void:
	hide()

func _render() -> void:
	npc_name.text = npc.display_name
	real_name.text = npc.real_name
	npc_icon.texture = npc.icon

	for child: Node in liked_effects.get_children():
		child.free()

	for effect: Effect in npc.likes:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.custom_minimum_size = Vector2(16, 16)
		liked_effects.add_child(effect_label)

	for child: Node in disliked_effects.get_children():
		child.free()

	for effect: Effect in npc.dislikes:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.custom_minimum_size = Vector2(16, 16)
		disliked_effects.add_child(effect_label)