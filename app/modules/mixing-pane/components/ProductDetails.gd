class_name ProductDetails
extends VBoxContainer

@onready var effect_list: EffectList = %EffectList
@onready var serve_button: Button = %ServeButton
@onready var product_display: ProductDisplay = %ProductDisplay
@onready var state_manager: ProductDetailsStateManager = %StateManager
@onready var product_type_warning: ProductTypeWarning = %ProductTypeWarning


func _ready() -> void:
	_connect_signals()
	_apply_state(ProductDetailsStateManager.STATE.HIDDEN, [])

func update_product_type(product_type: ProductType) -> void:
	state_manager.update_product_type(product_type)

func update_ingredients(ingredients: Dictionary[MixerButtons.SLOT, Ingredient]) -> void:
	var stats: MixtureIngredientStats = MixtureIngredientStats.new(ingredients)
	var mixture: Array[Effect] = _extract_mixture_from_stats(stats.effect_counts)
	state_manager.update_mixture(mixture)
	state_manager.update_unknown_effects_count(stats.ingredients_with_unknown_count)

func update_current_end_result(product: MixedProduct) -> void:
	state_manager.update_current_product(product)

func _connect_signals() -> void:
	state_manager.state_changed.connect(_on_state_changed)
	state_manager.mixture_changed.connect(_on_mixture_changed)

func _on_mixture_changed(mixture: Array[Effect]) -> void:
	effect_list.update_effect_icon_visibility(mixture)

func _on_state_changed(
	state: ProductDetailsStateManager.STATE,
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	_apply_state(state, mix_details_elements)

func _apply_state(
	state: ProductDetailsStateManager.STATE,
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	match state:
		ProductDetailsStateManager.STATE.HIDDEN:
			_apply_hidden_state()
		ProductDetailsStateManager.STATE.SHOWING_PRODUCT:
			_apply_showing_product_state()
		ProductDetailsStateManager.STATE.SHOWING_MIX_DETAILS:
			_apply_showing_mix_details_state(mix_details_elements)

func _apply_hidden_state() -> void:
	hide()
	effect_list.hide()
	serve_button.hide()
	product_display.hide()
	_clear_all_warnings()

func _apply_showing_product_state() -> void:
	show()
	effect_list.hide()
	serve_button.hide()
	product_display.show_product(state_manager.get_current_product())
	_clear_all_warnings()

func _apply_showing_mix_details_state(
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	_apply_mix_details_elements(mix_details_elements)
	effect_list.update_effect_icon_visibility(state_manager.get_mixture())
	effect_list.show()
	show()
	product_display.hide()

func _apply_mix_details_elements(
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	serve_button.hide()
	_clear_all_warnings()

	for mix_details_element: ProductDetailsStateManager.MIX_DETAILS_ELEMENTS in mix_details_elements:
		match mix_details_element:
			ProductDetailsStateManager.MIX_DETAILS_ELEMENTS.UNKNOWN_EFFECT_WARNING:
				effect_list.update_unknown_effect_warning_visibility(true)
			ProductDetailsStateManager.MIX_DETAILS_ELEMENTS.PRODUCT_TYPE_WARNING:
				product_type_warning.show()
			ProductDetailsStateManager.MIX_DETAILS_ELEMENTS.SERVE_BUTTON_VISIBLE:
				serve_button.show()

func _clear_all_warnings() -> void:
	effect_list.update_unknown_effect_warning_visibility(false)
	product_type_warning.hide()

func _extract_mixture_from_stats(effect_counts: Dictionary[Effect, int]) -> Array[Effect]:
	var mixture: Array[Effect] = []
	for effect: Effect in effect_counts.keys():
		if effect_counts[effect] >= 2:
			mixture.append(effect)
	return mixture
