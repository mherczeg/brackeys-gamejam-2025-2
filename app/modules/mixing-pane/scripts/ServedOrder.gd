class_name ServedOrder
extends RefCounted

var mixed_product: MixedProduct
var order_npc: NPC
var order_product: Product

func _init(
    _mixed_product: MixedProduct,
    _order_npc: NPC,
    _order_product: Product,
) -> void:
    mixed_product = _mixed_product
    order_npc = _order_npc
    order_product = _order_product
