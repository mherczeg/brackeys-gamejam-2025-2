class_name OrderHistoryElement
extends RefCounted

var npc: NPC
var product: MixedProduct
var reaction: MixedProduct.REACTION
var additional_effects: Array[Effect]

func _init(served_order: ServedOrder) -> void:
	product = served_order.mixed_product
	npc = served_order.order_npc
	reaction = served_order.mixed_product.get_complete_reaction(
		served_order.order_product,
		served_order.order_npc
	)
	additional_effects = served_order.mixed_product.get_additional_effects(
		served_order.order_product
	).keys()
