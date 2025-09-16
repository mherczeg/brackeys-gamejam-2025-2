class_name EffectList
extends VBoxContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const EFFECT_ICON_SIZE: Vector2i = Vector2i(32, 32)
const EFFECT_LABEL_GROUP: String = "product-details-effect-labels"

@onready var effect_icons: HBoxContainer = %EffectIcons
@onready var effect_icons_label: Label = %EffectIconsLabel
@onready var unknown_effect_warning: UnknownEffectsWarning = %UnknownEffectsWarning

func _ready() -> void:
	_initialize_effects()

func update_unknown_effect_warning_visibility(has_unknown_potential: bool) -> void:
	unknown_effect_warning.visible = has_unknown_potential

func update_effect_icon_visibility(mixture: Array[Effect]) -> void:
	var visible_count: int = 0

	for child: EffectLabelIcon in effect_icons.get_children():
		if !child.is_in_group(EFFECT_LABEL_GROUP):
			continue

		var should_show: bool = mixture.has(child.effect)
		child.visible = should_show
		if should_show:
			visible_count += 1

	effect_icons_label.visible = visible_count > 0

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
