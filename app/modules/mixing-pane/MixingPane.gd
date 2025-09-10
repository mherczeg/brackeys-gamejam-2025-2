class_name MixingPane
extends Control

const INGREDIENT_LIST_SPACING: int = 10

# TODO move these to a global or it will get out of hand
var _selected_product_type: ProductType:
	set(updated_product_type):
		_selected_product_type = updated_product_type
		if updated_product_type:
			mixer_buttons.update_product_type_icon(updated_product_type.icon)
		else:
			mixer_buttons.update_product_type_icon(null)
		product_details.update_product_type(updated_product_type)

var _selected_ingredients: Dictionary[MixerButtons.SLOT, Ingredient] = {}
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

@onready var mixer_buttons: MixerButtons = %MixerButtons
@onready var product_details: ProductDetails = %ProductDetails
@onready var order_details: OrderDetails = %OrderDetails
@onready var coin_insert: AudioStreamPlayer2D = $Audio/CoinInsert
@onready var product_drop: AudioStreamPlayer2D = $Audio/ProductDrop
@onready var left_margin: float = 0

func _ready() -> void:
	# ($Background as Panel).mouse_filter = MOUSE_FILTER_IGNORE
	EventBus.mixer.product_type_selected.connect(set_selected_product_type)
	EventBus.mixer.ingredient_selected.connect(set_next_slot_ingredient)
	EventBus.mixer.ingredient_selector_unset.connect(unset_slot_ingredient)
	EventBus.mixer.mixture_changed.connect(recalculate_mixture)
	product_details.serve_button_pressed.connect(_on_serve_button_pressed)
	recalculate_order()

func set_selected_product_type(product_type: ProductType) -> void:
	_selected_product_type = product_type
	EventBus.mixer.mixture_changed.emit(_selected_product_type, _selected_ingredients.values())

func set_next_slot_ingredient(ingredient: Ingredient) -> void:
	var next_slot: Variant = get_first_empty_slot()
	if (next_slot == null):
		return

	set_slot_ingredient(next_slot as MixerButtons.SLOT, ingredient)

func set_slot_ingredient(slot: MixerButtons.SLOT, ingredient: Ingredient) -> void:
	product_details.update_current_display_product(null)
	_selected_ingredients[slot] = ingredient
	mixer_buttons.update_slot_icon(slot, ingredient.icon)
	EventBus.mixer.mixture_changed.emit(_selected_product_type, _selected_ingredients.values())

func unset_slot_ingredient(slot: MixerButtons.SLOT) -> void:
	if _selected_ingredients.has(slot):
		_selected_ingredients.erase(slot)
		mixer_buttons.update_slot_icon(slot, null)
		EventBus.mixer.mixture_changed.emit(_selected_product_type, _selected_ingredients.values())

func get_first_empty_slot() -> Variant:
	for slot: MixerButtons.SLOT in mixer_buttons.slot_buttons.keys():
		if !_selected_ingredients.has(slot):
			return slot

	return null

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
		order_details.npc = null
		order_details.product = null
	else:
		order_details.npc = _current_npc
		order_details.product = _current_product

func recalculate_mixture(_b: ProductType, _i: Array[Ingredient]) -> void:
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
	EventBus.mixer.product_type_selected.emit(null)
	unset_slot_ingredient(MixerButtons.SLOT.FIRST)
	unset_slot_ingredient(MixerButtons.SLOT.SECOND)
	unset_slot_ingredient(MixerButtons.SLOT.THIRD)
	unset_slot_ingredient(MixerButtons.SLOT.FOURTH)

func _on_serve_button_pressed() -> void:
	var mixed_product: MixedProduct = MixedProduct.new()
	mixed_product.product_type = _selected_product_type
	mixed_product.ingredients = _selected_ingredients.values()
	coin_insert.stop()
	product_drop.play()
	await product_drop.finished
	EventBus.mixer.serve_mix.emit(mixed_product)
