class_name ProductDetails
extends VBoxContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const EFFECT_LABEL_GROUP: String = "product-details-effect-labels"
const EFFECT_ICON_SIZE: Vector2i = Vector2i(32, 32)

@onready var effect_list: VBoxContainer = %EffectList
@onready var effect_icons: HBoxContainer = %EffectIcons
@onready var serve_button: Button = %ServeButton
@onready var product_display: ProductDisplay = %ProductDisplay
@onready var state_manager: ProductDetailsStateManager = %StateManager


func _ready() -> void:
	_initialize_effects()
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

func _on_state_changed(
	state: ProductDetailsStateManager.STATE,
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	_apply_state(state, mix_details_elements)

func _apply_state(
	state: ProductDetailsStateManager.STATE,
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	prints("_apply_state")
	match state:
		ProductDetailsStateManager.STATE.HIDDEN:
			prints("hidden")
			_apply_hidden_state()
		ProductDetailsStateManager.STATE.SHOWING_PRODUCT:
			prints("product")
			_apply_showing_product_state()
		ProductDetailsStateManager.STATE.SHOWING_MIX_DETAILS:
			prints("mix")
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
	_update_mixture_list()
	show()
	# effect_list.show()
	product_display.hide()


# TODO get rid of signals
func _apply_mix_details_elements(
	mix_details_elements: Array[ProductDetailsStateManager.MIX_DETAILS_ELEMENTS]
) -> void:
	serve_button.hide()
	_clear_all_warnings()

	for mix_details_element: ProductDetailsStateManager.MIX_DETAILS_ELEMENTS in mix_details_elements:
		match mix_details_element:
			ProductDetailsStateManager.MIX_DETAILS_ELEMENTS.UNKNOWN_EFFECT_WARNING:
				prints("unknown warning")
				EventBus.mixer.unknown_effect_warning.emit(true)
			ProductDetailsStateManager.MIX_DETAILS_ELEMENTS.PRODUCT_TYPE_WARNING:
				prints("product type warning")
				EventBus.mixer.product_type_warning.emit(true)
			ProductDetailsStateManager.MIX_DETAILS_ELEMENTS.SERVE_BUTTON_VISIBLE:
				prints("serve button")
				serve_button.show()

func _clear_all_warnings() -> void:
	EventBus.mixer.unknown_effect_warning.emit(false)
	EventBus.mixer.product_type_warning.emit(false)

func _extract_mixture_from_stats(effect_counts: Dictionary[Effect, int]) -> Array[Effect]:
	var mixture: Array[Effect] = []
	for effect: Effect in effect_counts.keys():
		if effect_counts[effect] >= 2:
			mixture.append(effect)
	return mixture

func _update_mixture_list() -> void:
	var mixture: Array[Effect] = state_manager.get_mixture()
	var visible_count: int = 0

	for child: EffectLabelIcon in effect_icons.get_children():
		if !child.is_in_group(EFFECT_LABEL_GROUP):
			continue

		var should_show: bool = mixture.has(child.effect)
		child.visible = should_show
		if should_show:
			visible_count += 1

	print(visible_count)
	effect_list.visible = visible_count > 0 || state_manager.has_unknown_potential()

func _initialize_effects() -> void:
	for effect: Effect in ResourceManager.effects:
		effect_icons.add_child(_create_effect_label(effect))

func _create_effect_label(effect: Effect) -> EffectLabelIcon:
	var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
	effect_label.custom_minimum_size = EFFECT_ICON_SIZE
	effect_label.effect = effect
	effect_label.hide()
	effect_label.add_to_group(EFFECT_LABEL_GROUP)
	return effect_label
