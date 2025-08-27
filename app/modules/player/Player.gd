extends Node

var money: float = 0:
	set(new_money):
		money = new_money
		EventBus.player.money_changed.emit(new_money)

var health: int = 100

func _ready() -> void:
	EventBus.mixer.order_received.connect(_on_order_start)

func _on_order_start(product: Product) -> void:
	money += product.price
