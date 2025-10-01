class_name MixingPane
extends Control

signal impossible_order

@export var config: MixingPaneConfig

@onready var mixer_buttons: MixerButtons = %MixerButtons
@onready var product_details: ProductDetails = %ProductDetails
@onready var order_details: OrderDetails = %OrderDetails
@onready var audio_player: MixingPaneAudioPlayer = %MixingPaneAudioPlayer
@onready var mixer_state: MixerState = %MixerState
@onready var ingredient_selector: IngredientSelector = %IngredientSelector


func _ready() -> void:
	_configure_child_nodes()
	_connect_signals()
	update_by_order()

func _configure_child_nodes() -> void:
	if !config:
		push_warning("MixingPane: No config provided")
		return

	if audio_player:
		audio_player.set_coin_insert_delay(config.coin_insert_delay)

func _connect_signals() -> void:
	product_details.serve_button.pressed.connect(_on_serve_button_pressed)
	mixer_state.order_changed.connect(_on_mixer_state_order_changed)
	mixer_state.selection_changed.connect(_on_mixer_state_selection_changed)
	ingredient_selector.ingredient_selected.connect(_on_ingredient_selected)

	EventBus.mixer.product_type_selected.connect(_on_product_type_selected)
	EventBus.mixer.ingredient_selector_slot_cleared.connect(_on_ingredient_selector_slot_cleared)


func _get_ingredient_selector_position(ingredient_button: IngredientButton) -> Vector2:
	return Vector2(
		ingredient_button.position.x + ingredient_button.size.x + config.ingredient_list_spacing,
		config.ingredient_selector_y_offset # TODO, this should consider element count
	)

func start_encounter(encounter: Encounter) -> void:
	product_details.update_current_end_result(null)
	mixer_state.current_encounter = encounter

func complete_encounter() -> void:
	mixer_state.current_encounter = null
	mixer_state.current_npc = null

func start_new_order(npc: NPC) -> void:
	if Player.inventory.get_available_ingredients().size() < 2:
		impossible_order.emit()
		return
	await audio_player.play_coin_insert()
	reset_mixer()
	mixer_state.current_npc = npc
	if mixer_state.current_product:
		EventBus.mixer.order_received.emit(mixer_state.current_product)

func display_result(display_product: MixedProduct) -> void:
	reset_mixer()
	product_details.update_current_end_result(display_product)

func reset_mixer() -> void:
	EventBus.mixer.product_type_selected.emit(null)
	for slot: MixerButtons.SLOT in MixerButtons.SLOT.values():
		_on_ingredient_selector_slot_cleared(slot)

func _on_serve_button_pressed() -> void:
	var mixed_product: MixedProduct = MixedProduct.new(
		mixer_state.selected_product_type,
		mixer_state.selected_ingredients.values()
	)
	await audio_player.play_product_drop()
	EventBus.mixer.serve_mix.emit(ServedOrder.new(
		mixed_product,
		mixer_state.current_npc,
		mixer_state.current_product
	))

func _on_mixer_state_order_changed() -> void:
	update_by_order()

func _on_product_type_selected(product_type: ProductType) -> void:
	mixer_state.selected_product_type = product_type

func _on_ingredient_selected(ingredient: Ingredient) -> void:
	mixer_state.set_next_slot_ingredient(ingredient)

func _on_ingredient_selector_slot_cleared(slot: MixerButtons.SLOT) -> void:
	mixer_state.unset_slot_ingredient(slot)

func _on_mixer_state_selection_changed() -> void:
	product_details.update_current_end_result(null)
	product_details.update_product_type(mixer_state.selected_product_type)
	update_by_selection()

func update_by_order() -> void:
	order_details.update_details(mixer_state.current_npc, mixer_state.current_product)

func update_by_selection() -> void:
	product_details.update_ingredients(mixer_state.selected_ingredients)
	mixer_buttons.update_icons(mixer_state.selected_product_type, mixer_state.selected_ingredients)
	ingredient_selector.update_button_selection_states(mixer_state.selected_ingredients)
