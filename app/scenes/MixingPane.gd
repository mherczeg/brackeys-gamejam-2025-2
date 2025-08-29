class_name MixingPane
extends Control

const INGREDIENT_LIST_SPACING: int = 10

# TODO move these to a global or it will get out of hand
var _selected_base: Base:
	set(updated_base):
		_selected_base = updated_base
		if updated_base:
			mixer_buttons.update_base_icon(updated_base.icon)
		else:
			mixer_buttons.update_base_icon(null)
		product_details.update_base(updated_base)

var _selected_ingredients: Dictionary[IngredientButton.SLOT, Ingredient] = {}
var _current_encounter: Encounter = null
var _current_npc: NPC = null:
	set(new_npc):
		_current_npc = new_npc
		recalculate_order()

var _current_product: Product:
	get():
		if (_current_encounter == null || _current_npc == null):
			return null
		if !_current_encounter.order.has(_current_npc):
			return null
		return _current_encounter.order[_current_npc]

# Unfortunately this does not work
# var _selected_ingredients: Dictionary[IngredientButton.SLOT, Ingredient] = {}:
# 	set(updated_ingredients):
# 		_selected_ingredients = updated_ingredients
# 		print(_selected_ingredients)

@onready var ingredient_selector: IngredientSelector = $IngredientSelector
@onready var mixer_buttons: MixerButtons = %MixerButtons
@onready var product_details: ProductDetails = %ProductDetails
@onready var order_details: OrderDetails = %OrderDetails
@onready var base_warning: Label = %BaseWarning
@onready var unknown_effect_warning: Label = %UnknownEffectsWarning
@onready var coin_insert: AudioStreamPlayer2D = $CoinInsert
@onready var product_drop: AudioStreamPlayer2D = $ProductDrop
@onready var left_margin: float = 0

func _ready() -> void:
	# ($Background as Panel).mouse_filter = MOUSE_FILTER_IGNORE
	ingredient_selector.hide()
	EventBus.mixer.ingredient_selector_toggle.connect(toggle_ingredient_selector)
	EventBus.mixer.base_selected.connect(set_selected_base)
	EventBus.mixer.ingredient_selected.connect(set_slot_ingredient)
	EventBus.mixer.ingredient_selector_unset.connect(unset_slot_ingredient)
	EventBus.mixer.mixture_changed.connect(recalculate_mixture)
	product_details.serve_button_pressed.connect(_on_serve_button_pressed)
	recalculate_order()


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
		ingredient_selector.open(_selected_ingredients.values())

func set_selected_base(base: Base) -> void:
	_selected_base = base
	EventBus.mixer.mixture_changed.emit()

func set_slot_ingredient(slot: IngredientButton.SLOT, ingredient: Ingredient) -> void:
	product_details.update_current_display_product(null)
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

func start_encounter(encounter: Encounter) -> void:
	product_details.update_current_display_product(null)
	_current_encounter = encounter

func complete_encounter() -> void:
	_current_encounter = null
	_current_npc = null

func start_new_order(npc: NPC) -> void:
	product_drop.stop()
	coin_insert.play()
	await get_tree().create_timer(1.0).timeout
	reset_mixer()
	_current_npc = npc
	if _current_product:
		EventBus.mixer.order_received.emit(_current_product)

func display_result(display_product: MixedProduct) -> void:
	reset_mixer()
	product_details.update_current_display_product(display_product)

func recalculate_order() -> void:
	if !_current_product:
		order_details.set_simple_text("Idle text")
	else:
		order_details.set_order_with_texture(_current_npc, _current_product)

func recalculate_mixture() -> void:
	var effect_appeared_once_set: Dictionary[Effect, bool] = {}
	var mixture_known_effects_set: Dictionary[Effect, bool] = {}
	var ingredients_with_unknown_set: Dictionary[Ingredient, bool] = {}

	for ingredient: Ingredient in _selected_ingredients.values():
		for effect: Effect in ingredient.effects:
			if ingredient.is_effect_known(effect):
				if !effect_appeared_once_set.has(effect):
					effect_appeared_once_set[effect] = true
				elif !mixture_known_effects_set.has(effect):
					mixture_known_effects_set[effect] = true
			else:
				ingredients_with_unknown_set[ingredient] = true


	product_details.update_mixture(mixture_known_effects_set.keys(), ingredients_with_unknown_set.size())

func reset_mixer() -> void:
	set_selected_base(null)
	unset_slot_ingredient(IngredientButton.SLOT.FIRST)
	unset_slot_ingredient(IngredientButton.SLOT.SECOND)
	unset_slot_ingredient(IngredientButton.SLOT.THIRD)
	unset_slot_ingredient(IngredientButton.SLOT.FOURTH)
	ingredient_selector.hide()

func _on_serve_button_pressed() -> void:
	var mixed_product: MixedProduct = MixedProduct.new()
	mixed_product.base = _selected_base
	mixed_product.ingredients = _selected_ingredients.values()
	coin_insert.stop()
	product_drop.play()
	await product_drop.finished
	EventBus.mixer.serve_mix.emit(mixed_product)
