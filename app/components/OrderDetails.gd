class_name OrderDetails
extends PanelContainer

const EFFECT_LABEL_GROUP: String = "ingredient-selector-effects-label"
const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")

@export var product: Product:
	set(_new_product):
		product = _new_product
		update_ui()

@export var npc: NPC:
	set(_new_npc):
		npc = _new_npc
		update_ui()

@onready var idle_label: Label = $IdleLabel
@onready var product_info: VBoxContainer = $ProductInfo
@onready var npc_name: Label = $ProductInfo/Control/NPCName
@onready var product_icon: TextureRect = $ProductInfo/Control/ProductIcon
@onready var base_icon: TextureRect = $ProductInfo/Recipe/Base/BaseIcon
@onready var effect_list: FlowContainer = $ProductInfo/Recipe

func _ready() -> void:
	npc_name.mouse_entered.connect(_on_npc_name_hover_start)
	npc_name.mouse_exited.connect(_on_npc_name_hover_end)

func update_ui() -> void:
	if (!npc || !product):
		idle_label.show()
		product_info.hide()
		return

	npc_name.text = npc.display_name
	product_icon.texture = product.icon
	product_icon.tooltip_text = product.name
	base_icon.texture = product.base.icon
	base_icon.tooltip_text = product.base.name

	for child: Node in effect_list.get_children():
		if child.is_in_group(EFFECT_LABEL_GROUP):
			child.free()

	for effect: Effect in product.effects:
		var effect_label: EffectLabel = EFFECT_LABEL_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.add_to_group(EFFECT_LABEL_GROUP)
		effect_label.has_plus = true
		effect_list.add_child(effect_label)
		effect_label.icon.custom_minimum_size = Vector2i(32, 32)

	idle_label.hide()
	product_info.show()

func _on_npc_name_hover_start() -> void:
	EventBus.ui.show_npc_info.emit(npc, get_global_mouse_position() + Vector2(32, 32))

func _on_npc_name_hover_end() -> void:
	EventBus.ui.hide_npc_info.emit()
