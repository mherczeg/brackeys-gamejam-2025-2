class_name MixerEvents
extends Node

signal product_type_selected(product_type: ProductType)
signal ingredient_selector_slot_cleared(slot: MixerButtons.SLOT)
signal serve_mix(product: MixedProduct)
signal ingredient_effects_unlocked
signal order_received(product: Product)