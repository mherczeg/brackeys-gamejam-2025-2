class_name EffectLabelIcon
extends TextureRect

var effect: Effect


func _ready() -> void:
    if effect:
        texture = effect.icon