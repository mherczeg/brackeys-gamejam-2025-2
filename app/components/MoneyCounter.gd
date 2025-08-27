class_name MoneyCounter
extends HBoxContainer

@onready var money_label: Label = $Label

func _ready() -> void:
    EventBus.player.money_changed.connect(_on_money_changed)

func _on_money_changed(new_money: float) -> void:
    money_label.text = '$ %d' % new_money