class_name EffectLabel
extends HBoxContainer

@export var has_plus: bool = false
var effect: Effect

@onready var icon: TextureRect = $Icon
@onready var name_label: Label = $Name
@onready var plus: Label = $Plus

func _ready() -> void:
    if effect:
        icon.texture = effect.icon
        name_label.text = effect.name


    if has_plus:
        plus.show()
    else:
        plus.hide()
