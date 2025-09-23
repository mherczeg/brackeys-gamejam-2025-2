class_name NPCInfoBox
extends PanelContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const ORDER_HISTORY_ITEM_SCENE: PackedScene = preload("res://modules/npc-db/components/OrderHistoryItem.tscn")

@export var npc: NPC

var orders: Array[OrderHistoryElement] = []

@onready var npc_name: Label = %NPCName
@onready var real_name: Label = %RealName
@onready var npc_icon: TextureRect = %NPCIcon
@onready var liked_effects: HBoxContainer = %LikedEffets
@onready var disliked_effects: HBoxContainer = %DislikedEffects
@onready var order_history: ScrollContainer = %OrderHistory
@onready var order_history_items: VBoxContainer = %OrderHistoryItems

func set_npc(new_npc: NPC, new_orders: Array[OrderHistoryElement] = []) -> void:
	if (npc == new_npc):
		return

	npc = new_npc
	orders = new_orders

	_render()

func _render() -> void:
	npc_name.text = npc.display_name
	real_name.text = npc.real_name
	npc_icon.texture = npc.icon

	_render_likes()
	_render_dislikes()
	_render_orders()

func _render_likes() -> void:
	Utils.clear_children(liked_effects)

	for effect: Effect in npc.likes:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.custom_minimum_size = Vector2(16, 16)
		liked_effects.add_child(effect_label)

func _render_dislikes() -> void:
	Utils.clear_children(disliked_effects)

	for effect: Effect in npc.dislikes:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.custom_minimum_size = Vector2(16, 16)
		disliked_effects.add_child(effect_label)

func _render_orders() -> void:
	Utils.clear_children(order_history_items)

	for order: OrderHistoryElement in orders:
		order_history_items.add_child(_create_order_history_item(order))

func _create_order_history_item(order: OrderHistoryElement) -> OrderHistoryItem:
	var order_history_item: OrderHistoryItem = ORDER_HISTORY_ITEM_SCENE.instantiate()
	order_history_item.order = order

	return order_history_item
