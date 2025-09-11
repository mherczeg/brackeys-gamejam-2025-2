class_name ProductDetailsStateManager
extends Node

signal state_changed(state: STATE, mix_details_elements: Array[MIX_DETAILS_ELEMENTS])


enum STATE {
	HIDDEN,
	SHOWING_PRODUCT,
	SHOWING_MIX_DETAILS
}

enum MIX_DETAILS_ELEMENTS {
	UNKNOWN_EFFECT_WARNING,
	PRODUCT_TYPE_WARNING,
	SERVE_BUTTON_VISIBLE
}

var current_state: STATE = STATE.HIDDEN
var current_mix_details_elements: Array[MIX_DETAILS_ELEMENTS] = []

var _mixture: Array[Effect] = []
var _ingredients_with_unknown_effect: int = 0
var _product_type: ProductType
var _current_display_product: MixedProduct


func update_mixture(mixture: Array[Effect]) -> void:
	_mixture = mixture
	_evaluate_state()

func update_unknown_effects_count(count: int) -> void:
	_ingredients_with_unknown_effect = count
	_evaluate_state()

func update_product_type(product_type: ProductType) -> void:
	_product_type = product_type
	_evaluate_state()

func update_current_product(product: MixedProduct) -> void:
	_current_display_product = product
	_evaluate_state()

func _evaluate_state() -> void:
	var new_state: STATE = _determine_state()
	var new_mix_details_elements: Array[MIX_DETAILS_ELEMENTS] = \
		_determine_mix_details_elements(new_state)


	if _has_state_changed(new_state, new_mix_details_elements):
		current_state = new_state
		current_mix_details_elements = new_mix_details_elements
		state_changed.emit(current_state, current_mix_details_elements)


func _has_state_changed(
	new_state: STATE,
	new_mix_details_elements: Array[MIX_DETAILS_ELEMENTS]
) -> bool:
	return new_state != current_state || !_are_mix_detail_elements_equal(
		new_mix_details_elements,
		current_mix_details_elements
	)

func _determine_state() -> STATE:
	if _current_display_product:
		return STATE.SHOWING_PRODUCT

	if _has_mix_information():
		return STATE.SHOWING_MIX_DETAILS

	return STATE.HIDDEN

func _determine_mix_details_elements(state: STATE) -> Array[MIX_DETAILS_ELEMENTS]:
	var mix_details_elements: Array[MIX_DETAILS_ELEMENTS] = []

	if state != STATE.SHOWING_MIX_DETAILS:
		return mix_details_elements

	if _has_unknown_potential():
		mix_details_elements.append(MIX_DETAILS_ELEMENTS.UNKNOWN_EFFECT_WARNING)

	if !_product_type:
		mix_details_elements.append(MIX_DETAILS_ELEMENTS.PRODUCT_TYPE_WARNING)

	if _is_craftable():
		mix_details_elements.append(MIX_DETAILS_ELEMENTS.SERVE_BUTTON_VISIBLE)

	return mix_details_elements

func _has_mix_information() -> bool:
	return _ingredients_with_unknown_effect >= 2 || _mixture.size() > 0

func _has_unknown_potential() -> bool:
	return _ingredients_with_unknown_effect >= 2 || \
			(_mixture.size() > 0 && _ingredients_with_unknown_effect == 1)

func _is_craftable() -> bool:
	return _product_type != null && _has_mixable_effect()

func _has_mixable_effect() -> bool:
	return _has_unknown_potential() || _has_mix_information()

func _are_mix_detail_elements_equal(
	a: Array[MIX_DETAILS_ELEMENTS],
	b: Array[MIX_DETAILS_ELEMENTS]
) -> bool:
	if a.size() != b.size():
		return false
	for item: MIX_DETAILS_ELEMENTS in a:
		if !b.has(item):
			return false
	return true

func has_unknown_potential() -> bool:
	return _has_unknown_potential()

func get_mixture() -> Array[Effect]:
	return _mixture.duplicate()

func get_current_product() -> MixedProduct:
	return _current_display_product
