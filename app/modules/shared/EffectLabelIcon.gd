class_name EffectLabelIcon
extends TextureRect

@export var effect: Effect:
	set(new_effect):
		effect = new_effect
		_apply_effect()

func _ready() -> void:
	_apply_effect()

func _apply_effect() -> void:
	if effect:
		texture = effect.icon
		tooltip_text = effect.name
	else:
		texture = null
		tooltip_text = ""