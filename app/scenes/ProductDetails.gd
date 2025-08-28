class_name ProductDetails
extends VBoxContainer

signal serve_button_pressed

const EFFECTS_PATH: String = "res://resources/effects"
const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://components/EffectLabelIcon.tscn")
const EFFECT_LABEL_GROUP: String = "product-details-effect-labels"

var _mixture: Array[Effect] = []
var _ingredients_with_unknown_effect: int = 0
var _base: Base

var _has_mix_information: bool:
	get():
		if _ingredients_with_unknown_effect >= 2:
			return true
		if _mixture.size() > 0:
			return true
		return false

var _has_unknown_potential: bool:
	get():
		if _ingredients_with_unknown_effect >= 2:
			return true
		if _mixture.size() > 0 && _ingredients_with_unknown_effect == 1:
			return true
		return false

var _is_craftable: bool:
	get():
		return _base && (_has_unknown_potential || _has_mix_information)

var _current_display_product: MixedProduct:
	set(new_product):
		_current_display_product = new_product
		update_content()

@onready var effect_list: VBoxContainer = $EffectList
@onready var effect_icons: HBoxContainer = $EffectList/EffectIcons
@onready var server_button: Button = $ServeButton
@onready var product_display: ProductDisplay = $ProductDisplay

func _ready() -> void:
	hide()
	_load_all_effects()
	server_button.pressed.connect(serve_button_pressed.emit)

func update_base(updated_base: Base) -> void:
	_base = updated_base
	update_content()

func update_mixture(updated_mixture: Array[Effect], ingredients_with_unknown_effect: int) -> void:
	_mixture = updated_mixture
	_ingredients_with_unknown_effect = ingredients_with_unknown_effect
	update_content()

func update_content() -> void:
	update_mixture_list()
	update_visibility()

func update_current_display_product(product: MixedProduct) -> void:
	_current_display_product = product

func update_mixture_list() -> void:
	var visible_icons: int = 0
	for child: EffectLabelIcon in effect_icons.get_children():
		if child.is_in_group(EFFECT_LABEL_GROUP):
			if _mixture.has(child.effect):
				visible_icons += 1
				child.show()
			else:
				child.hide()

	if visible_icons > 0:
		effect_list.show()
	else:
		effect_list.hide()

func update_visibility() -> void:
	if _has_mix_information || _current_display_product:
		show()
	else:
		hide()

	if _current_display_product:
		product_display.show_product(_current_display_product)
	else:
		product_display.hide()

	if _has_unknown_potential:
		EventBus.mixer.unknown_effect_warning.emit(true)
	else:
		EventBus.mixer.unknown_effect_warning.emit(false)

	if _base || _current_display_product:
		EventBus.mixer.base_warning.emit(false)
	else:
		EventBus.mixer.base_warning.emit(true)

	if _is_craftable:
		server_button.show()
	else:
		server_button.hide()

func _load_all_effects() -> void:
	for effect: Effect in ResourceManager.effects:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.custom_minimum_size = Vector2(32, 32)
		effect_label.hide()
		effect_label.add_to_group(EFFECT_LABEL_GROUP)
		effect_icons.add_child(effect_label)
