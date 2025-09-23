class_name OrderHistory
extends Resource

var _orders: Array[OrderHistoryElement] = []
var _served_npcs: Dictionary[NPC, bool] = {}

func add_order(served_order: ServedOrder) -> void:
	var order_history_element: OrderHistoryElement = OrderHistoryElement.new(served_order)
	_orders.append(order_history_element)
	meet_npc(served_order.order_npc)
	log_likes(order_history_element)

func get_served_npcs() -> Array[NPC]:
	return _served_npcs.keys()

func get_npc_orders(npc: NPC) -> Array[OrderHistoryElement]:
	return _orders.filter(_is_npc_order.bind(npc))

func _is_npc_order(order: OrderHistoryElement, npc: NPC) -> bool:
	return order.npc == npc

func meet_npc(npc: NPC) -> void:
	if !_served_npcs.has(npc):
		_served_npcs[npc] = true

func log_likes(_order_history_element: OrderHistoryElement) -> void:
	pass