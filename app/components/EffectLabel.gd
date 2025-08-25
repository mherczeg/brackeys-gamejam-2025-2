class_name EffectLabel
extends HBoxContainer

var effect: Effect

@onready var icon: TextureRect = $Icon
@onready var name_label: Label = $Name

func _ready() -> void:
    if effect:
        icon.texture = effect.icon
        name_label.text = effect.name