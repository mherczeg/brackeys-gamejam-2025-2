class_name OrderHistoryItem
extends VBoxContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const EFFECT_ICON_SIZE: Vector2i = Vector2i(32, 32)

@export var ingredients: Array[Ingredient] = []
@export var product_type: ProductType = null
@export var effects: Array[Effect] = []

@onready var ingredient_list: HBoxContainer = %IngredientList
@onready var effect_list: HBoxContainer = %EffectList
@onready var no_effects_label: Label = %NoEffectsLabel
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
	if !product_type || ingredients.size() == 0:
		product_type_icon.texture = null
		ingredient_list.hide()
		return

	_render_product_type()
	_render_ingredients()
	_render_effects()

func _render_product_type() -> void:
	product_type_icon.product_type = product_type

func _render_ingredients() -> void:
	ingredient_list.show()
	for ingredient_index: int in ingredient_icons.size():
		_update_ingredient_icon(ingredient_index)

func _render_effects() -> void:
	_clear_effects()

	if effects.size() > 0:
		no_effects_label.hide()

	for effect: Effect in effects:
		effect_list.add_child(_create_effect_label(effect))


func _update_ingredient_icon(ingredient_index: int) -> void:
	if ingredients.size() > ingredient_index:
		ingredient_icons[ingredient_index].ingredient = ingredients[ingredient_index]
		ingredient_icons[ingredient_index].show()
	else:
		ingredient_icons[ingredient_index].hide()

func _clear_effects() -> void:
	no_effects_label.show()
	for child: Node in effect_list.get_children():
		child.free()

func _create_effect_label(effect: Effect) -> EffectLabelIcon:
	var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
	effect_label.custom_minimum_size = EFFECT_ICON_SIZE
	effect_label.effect = effect
	return effect_label
