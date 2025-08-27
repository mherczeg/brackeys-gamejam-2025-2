class_name ProductDetails
extends VBoxContainer

const EFFECTS_PATH: String = "res://resources/effects"
const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")
const EFFECT_LABEL_GROUP: String = "product-details-effect-labels"

var _mixture: Array[Effect] = []
var _has_unknown_effects: bool = false
var _base: Base

@onready var effect_list: VBoxContainer = $EffectList
@onready var server_button: Button = $ServeButton
@onready var base_warning: Label = $BaseWarning
@onready var unknown_effect_warning: Label = $UnkownEffectsWarning

func _ready() -> void:
	hide()
	_load_all_effects()

func update_base(updated_base: Base) -> void:
	_base = updated_base
	update_content()

func update_mixture(updated_mixture: Array[Effect], has_unknown_effects: bool) -> void:
	_mixture = updated_mixture
	_has_unknown_effects = has_unknown_effects
	update_content()

func update_content() -> void:
	update_mixture_list()
	update_validation()
	update_visibility()

func update_mixture_list() -> void:
	for child: EffectLabel in effect_list.get_children():
		if child.is_in_group(EFFECT_LABEL_GROUP):
			if _mixture.has(child.effect):
				child.show()
			else:
				child.hide()

func update_validation() -> void:
	if _base:
		server_button.show()
		base_warning.hide()
	else:
		server_button.hide()
		base_warning.show()

	if _has_unknown_effects:
		unknown_effect_warning.show()
	else:
		unknown_effect_warning.hide()

func update_visibility() -> void:
	if (!_mixture.size()):
		hide()
	else:
		show()

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
