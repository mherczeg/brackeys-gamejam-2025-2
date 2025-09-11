class_name OrderDetails
extends PanelContainer

const EFFECT_LABEL_GROUP: String = "ingredient-selector-effects-label"
const EFFECT_LABEL_SCENE: PackedScene = preload("res://modules/shared/EffectLabel.tscn")
const TOOLTIP_OFFSET: Vector2 = Vector2(32, 32)
const EFFECT_ICON_SIZE: Vector2i = Vector2i(32, 32)

var _product: Product = null
var _npc: NPC = null

@onready var idle_label: Label = $IdleLabel
@onready var product_info: VBoxContainer = $ProductInfo
@onready var npc_name: Label = $ProductInfo/Control/NPCName
@onready var product_icon: TextureRect = $ProductInfo/Control/ProductIcon
@onready var product_type_icon: TextureRect = $ProductInfo/Recipe/ProductType/Icon
@onready var effect_list: FlowContainer = $ProductInfo/Recipe

func _ready() -> void:
	_connect_signals()
	_update_ui()

func _connect_signals() -> void:
	npc_name.mouse_entered.connect(_on_npc_name_hover_start)
	npc_name.mouse_exited.connect(_on_npc_name_hover_end)

func update_details(npc: NPC, product: Product) -> void:
	if !product:
		_npc = null
		_product = null
	else:
		_npc = npc
		_product = product

	_update_ui()

func _update_ui() -> void:
	var has_data: bool = _has_required_data()
	idle_label.visible = !has_data
	product_info.visible = has_data

	if has_data:
		_update_npc_details()
		_update_product_details()
		_update_effect_labels()

func _has_required_data() -> bool:
	return _npc != null and _product != null

func _update_npc_details() -> void:
	npc_name.text = _npc.display_name

func _update_product_details() -> void:
	_update_product_icon()
	_update_product_type_icon()

func _update_product_icon() -> void:
	product_icon.texture = _product.icon
	product_icon.tooltip_text = _product.name

func _update_product_type_icon() -> void:
	product_type_icon.texture = _product.product_type.icon
	product_type_icon.tooltip_text = _product.product_type.name

func _update_effect_labels() -> void:
	_clear_existing_effect_labels()
	_create_effect_labels()

func _clear_existing_effect_labels() -> void:
	for child: Node in effect_list.get_children():
		if child.is_in_group(EFFECT_LABEL_GROUP):
			child.free()

func _create_effect_labels() -> void:
	for effect: Effect in _product.effects:
		_create_effect_label(effect)

func _create_effect_label(effect: Effect) -> void:
	var effect_label: EffectLabel = EFFECT_LABEL_SCENE.instantiate()
	effect_label.effect = effect
	effect_label.add_to_group(EFFECT_LABEL_GROUP)
	effect_label.has_plus = true
	effect_list.add_child(effect_label)
	effect_label.icon.custom_minimum_size = EFFECT_ICON_SIZE

func _on_npc_name_hover_start() -> void:
	EventBus.ui.show_npc_info.emit(_npc, get_global_mouse_position() + TOOLTIP_OFFSET)

func _on_npc_name_hover_end() -> void:
	EventBus.ui.hide_npc_info.emit()
