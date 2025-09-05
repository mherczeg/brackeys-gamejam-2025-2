class_name EffectLabelIcon
extends TextureRect

@export var effect: Effect


func _ready() -> void:
    if effect:
        texture = effect.icon
        tooltip_text = effect.name