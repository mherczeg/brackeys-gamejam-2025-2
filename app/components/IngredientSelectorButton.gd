class_name IngredientSelectorButton
extends TextureButton

signal disabled_changed

const EFFECT_LABEL_GROUP: String = "ingredient-selector-effect-label"
const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://components/EffectLabelIcon.tscn")
const UNKNOWN_EFFECT_LABEL_SCENE: PackedScene = preload("res://components/UnknownEffectLabel.tscn")

@export var ingredient: Ingredient
var slot: IngredientButton.SLOT
var _selected_for_mixture: bool = false
# @onready var button: TextureButton = $PanelContainer/Button
@onready var inventory_label: Label = $InventoryLabel
# @onready var effect_container: GridContainer = $EffectsContainer
# @onready var effect_containers: Array[EffectLabelIcon] = [
# 	$PanelContainer/EffectLabelIcon,
# 	$PanelContainer/EffectLabelIcon2,
# 	$PanelContainer/EffectLabelIcon3,
# 	$PanelContainer/EffectLabelIcon4
# ]
# @onready var name_label: Label = %Name
# @onready var effects: HBoxContainer = %Effects
# @onready var unknown_effect_label: UnknownEffectLabel
# @onready var description_label: Label = %Description

func _ready() -> void:
	texture_normal = ingredient.icon
	_update_ingredient_availability()

	pressed.connect(_on_pressed)
	EventBus.player.ingredient_stock_changed.connect(_on_ingredient_stock_changed)
	EventBus.mixer.mixture_changed.connect(_update_ingredient_selected)

func _on_pressed() -> void:
	EventBus.mixer.ingredient_selected.emit(ingredient)

func _update_ingredient_availability() -> void:
	var ingredient_count: int = 0
	if Player.ingredients.has(ingredient):
		ingredient_count = Player.ingredients[ingredient]
		show()
	else:
		hide()
	inventory_label.text = "%d" % ingredient_count

	if ingredient_count > 0 && !_selected_for_mixture:
		disabled = false
	else:
		disabled = true

	disabled_changed.emit()

func _update_ingredient_selected(_selected_base: Base, _selected_ingredients: Array[Ingredient]) -> void:
	_selected_for_mixture = _selected_ingredients.has(ingredient)

	_update_ingredient_availability()

func _on_ingredient_stock_changed(changed_ingredient: Ingredient) -> void:
	if changed_ingredient == ingredient:
		_update_ingredient_availability()
