extends Control

const INGREDIENT_LIST_SPACING: int = 10

# TODO move these to a global or it will get out of hand
var _selected_base: Base:
	set(updated_base):
		_selected_base = updated_base
		mixer_buttons.update_base_icon(updated_base.icon)
		product_details.update_base(updated_base)

var _mixture: Dictionary[Effect, bool] = {}:
	set(updated_mixture):
		_mixture = updated_mixture
		product_details.update_mixture(updated_mixture)


var _selected_ingredients: Dictionary[IngredientButton.SLOT, Ingredient] = {}

# Unfortunately this does not work
# var _selected_ingredients: Dictionary[IngredientButton.SLOT, Ingredient] = {}:
# 	set(updated_ingredients):
# 		_selected_ingredients = updated_ingredients
# 		print(_selected_ingredients)

@onready var ingredient_selector: ScrollContainer = $IngredientSelector
@onready var mixer_buttons: MixerButtons = %MixerButtons
@onready var product_details: ProductDetails = %ProductDetails
@onready var left_margin: float = ($MixingWrapper as BoxContainer).offset_left

func _ready() -> void:
	($Background as Panel).mouse_filter = MOUSE_FILTER_IGNORE
	ingredient_selector.hide()
	EventBus.mixer.ingredient_selector_toggle.connect(toggle_ingredient_selector)
	EventBus.mixer.base_selected.connect(set_selected_base)
	EventBus.mixer.ingredient_selected.connect(set_slot_ingredient)
	EventBus.mixer.ingredient_selector_unset.connect(unset_slot_ingredient)
	EventBus.mixer.mixture_changed.connect(recalculate_mixture)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:
				if ingredient_selector.visible:
					ingredient_selector.hide()

func toggle_ingredient_selector(slot: IngredientButton.SLOT) -> void:
	if ingredient_selector.visible:
		ingredient_selector.hide()
	else:
		var ingredient_button: IngredientButton = mixer_buttons.get_slot_button(slot)
		ingredient_selector.position = _get_ingredient_selector_position(ingredient_button)
		ingredient_selector.show()

func set_selected_base(base: Base) -> void:
	_selected_base = base
	EventBus.mixer.mixture_changed.emit()

func set_slot_ingredient(slot: IngredientButton.SLOT, ingredient: Ingredient) -> void:
	_selected_ingredients[slot] = ingredient
	mixer_buttons.update_slot_icon(slot, ingredient.icon)
	ingredient_selector.hide()
	EventBus.mixer.mixture_changed.emit()

func unset_slot_ingredient(slot: IngredientButton.SLOT) -> void:
	if _selected_ingredients.has(slot):
		_selected_ingredients.erase(slot)
		mixer_buttons.update_slot_icon(slot, null)
		EventBus.mixer.mixture_changed.emit()

func _get_ingredient_selector_position(ingredient_button: IngredientButton) -> Vector2:
	return Vector2(
		left_margin + ingredient_button.position.x + ingredient_button.size.x + INGREDIENT_LIST_SPACING,
		100 # TODO, this should consider element count
	)

func recalculate_mixture() -> void:
	var effect_set: Dictionary[Effect, int] = {}
	var mixture: Dictionary[Effect, bool] = {}

	for ingredient: Ingredient in _selected_ingredients.values():
		for effect: Effect in ingredient.effects.keys():
			if (!effect_set.has(effect)):
				effect_set[effect] = 0
			# this elif is important, since we only want to track how many 
			elif ingredient.effects[effect]:
				effect_set[effect] += 1

	for effect: Effect in effect_set.keys():
		mixture[effect] = effect_set[effect] > 1

	_mixture = mixture
