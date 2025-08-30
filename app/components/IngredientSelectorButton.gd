class_name IngredientSelectorButton
extends TextureButton

signal disabled_changed

const EFFECT_LABEL_GROUP: String = "ingredient-selector-effects-label"
const UNKNOWN_EFFECT_GROUP: String = "ingredient-selector-unknown-effects"
const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://components/EffectLabelIcon.tscn")
const UNKNOWN_EFFECT_LABEL_SCENE: PackedScene = preload("res://components/UnknownEffectLabel.tscn")

@export var ingredient: Ingredient
var slot: IngredientButton.SLOT
var _selected_for_mixture: bool = false

@onready var inventory_label: Label = $InventoryLabel
@onready var ingredient_name: Label = $MarginContainer/VBoxContainer/Name
@onready var effect_list: HBoxContainer = $MarginContainer/VBoxContainer/EffectList

func _ready() -> void:
	texture_normal = ingredient.icon
	ingredient_name.text = ingredient.name

	_render_effect_labels()
	_update_ingredient_availability()

	pressed.connect(_on_pressed)
	EventBus.player.ingredient_stock_changed.connect(_on_ingredient_stock_changed)
	EventBus.mixer.ingredient_effects_unlocked.connect(_update_effect_labels)
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

func _render_effect_labels() -> void:
	var has_unknown_effects: bool = false
	for effect: Effect in ingredient.effects:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.custom_minimum_size = Vector2(16, 16)
		effect_label.add_to_group(EFFECT_LABEL_GROUP)

		if !ingredient.is_effect_known(effect):
			effect_label.hide()
			has_unknown_effects = true

		effect_list.add_child(effect_label)

	var unknown_label: UnknownEffectLabel = UNKNOWN_EFFECT_LABEL_SCENE.instantiate()
	unknown_label.add_to_group(UNKNOWN_EFFECT_GROUP)
	if (!has_unknown_effects):
		unknown_label.hide()
	effect_list.add_child(unknown_label)

func _update_effect_labels() -> void:
	for node: Node in effect_list.get_children():
		if node.is_in_group(EFFECT_LABEL_GROUP):
			var effect_label: EffectLabelIcon = node
			if (ingredient.is_effect_known(effect_label.effect)):
				effect_label.show()
			else:
				effect_label.hide()
		if node.is_in_group(UNKNOWN_EFFECT_GROUP):
			if ingredient.has_unknown_effect():
				node.show()
			else:
				node.hide()
