class_name OrderHistoryItem
extends VBoxContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const EFFECT_ICON_SIZE: Vector2i = Vector2i(32, 32)
const LIKED_TEXT: String = "The customer liked this product"
const DISLIKED_TEXT: String = "The customer did not like this product"
const UNFULFILLED_TEXT: String = "This wasn't what the customer ordered"

var order: OrderHistoryElement

@onready var ingredient_list: HBoxContainer = %IngredientList
@onready var effect_list: HBoxContainer = %EffectList
@onready var no_effects_label: Label = %NoEffectsLabel
@onready var reaction_label: Label = %ReactionLabel
@onready var product_type_icon: ProductTypeLabelIcon = $IngredientList/ProductType
@onready var ingredient_icons: Array[IngredientLabelIcon] = [
	$IngredientList/Ingredient1,
	$IngredientList/Ingredient2,
	$IngredientList/Ingredient3,
	$IngredientList/Ingredient4
]

func _ready() -> void:
	render()

func render() -> void:
	if !_is_order_valid():
		product_type_icon.texture = null
		ingredient_list.hide()
		reaction_label.hide()
		return

	_render_product_type()
	_render_ingredients()
	_render_effects()
	_render_reaction()

func _render_product_type() -> void:
	product_type_icon.product_type = order.product.product_type

func _render_ingredients() -> void:
	ingredient_list.show()
	for ingredient_index: int in ingredient_icons.size():
		_update_ingredient_icon(ingredient_index)

func _render_effects() -> void:
	_clear_effects()

	if order.product.effects.size() > 0:
		no_effects_label.hide()

	for effect: Effect in order.product.effects:
		effect_list.add_child(_create_effect_label(effect))

func _render_reaction() -> void:
	match order.reaction:
		MixedProduct.REACTION.UNFULFILLED:
			reaction_label.show()
			reaction_label.text = UNFULFILLED_TEXT
		MixedProduct.REACTION.LIKES:
			reaction_label.show()
			reaction_label.text = LIKED_TEXT
		MixedProduct.REACTION.DISLIKES:
			reaction_label.show()
			reaction_label.text = DISLIKED_TEXT
		_:
			reaction_label.hide()


func _update_ingredient_icon(ingredient_index: int) -> void:
	if order.product.ingredients.size() > ingredient_index:
		ingredient_icons[ingredient_index].ingredient = order.product.ingredients[ingredient_index]
		ingredient_icons[ingredient_index].show()
	else:
		ingredient_icons[ingredient_index].hide()

func _clear_effects() -> void:
	no_effects_label.show()
	Utils.clear_children(effect_list)

func _create_effect_label(effect: Effect) -> EffectLabelIcon:
	var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
	effect_label.custom_minimum_size = EFFECT_ICON_SIZE
	effect_label.effect = effect
	return effect_label

func _is_order_valid() -> bool:
	if !_has_order_product():
		return false

	if !order.product.product_type:
		return false

	if order.product.ingredients.size() == 0:
		return false

	return true

func _has_order_product() -> bool:
	return order != null && order.product != null
