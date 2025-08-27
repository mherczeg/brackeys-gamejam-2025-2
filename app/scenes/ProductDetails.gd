class_name ProductDetails
extends VBoxContainer

signal serve_button_pressed

const EFFECTS_PATH: String = "res://resources/effects"
const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")
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


@onready var effect_list: VBoxContainer = $EffectList
@onready var server_button: Button = $ServeButton
@onready var base_warning: Label = $BaseWarning
@onready var unknown_effect_warning: Label = $UnkownEffectsWarning

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

func update_mixture_list() -> void:
	for child: EffectLabel in effect_list.get_children():
		if child.is_in_group(EFFECT_LABEL_GROUP):
			if _mixture.has(child.effect):
				child.show()
			else:
				child.hide()

func update_visibility() -> void:
	if _has_mix_information:
		show()
	else:
		hide()

	if _has_unknown_potential:
		unknown_effect_warning.show()
	else:
		unknown_effect_warning.hide()

	if _base:
		base_warning.hide()
	else:
		base_warning.show()

	if _is_craftable:
		server_button.show()
	else:
		server_button.hide()

func _load_all_effects() -> void:
	var dir: DirAccess = DirAccess.open(EFFECTS_PATH)
	if dir:
		for file_name: String in dir.get_files():
			if file_name.ends_with(".tres"):
				var resource: Resource = load(EFFECTS_PATH.path_join(file_name))
				if resource is Effect:
					var effect_label: EffectLabel = EFFECT_LABEL_SCENE.instantiate()
					effect_label.effect = resource
					effect_label.hide()
					effect_label.add_to_group(EFFECT_LABEL_GROUP)
					effect_list.add_child(effect_label)
