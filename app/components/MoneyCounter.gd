class_name MoneyCounter
extends HBoxContainer

@onready var money_label: Label = $Label

func _ready() -> void:
    update_money_label(Player.money)
    EventBus.player.money_changed.connect(update_money_label)

func update_money_label(new_money: float) -> void:
    money_label.text = '$ %d' % new_money