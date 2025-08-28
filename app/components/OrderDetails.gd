class_name OrderDetails
extends RichTextLabel


func _ready() -> void:
	bbcode_enabled = true


func set_simple_text(simple_text: String) -> void:
	clear()

	append_text(simple_text)


func set_order_with_texture(npc: NPC, product: Product) -> void:
	clear()

	append_text("%s wants a " % npc.display_name)

	add_image(product.icon, 16, 16)

	append_text(" %s" % product.name)

	append_text(".Ingredients:\n- ")

	add_image(product.base.icon, 16, 16)

	append_text(" %s" % product.base.name)

	for effect: Effect in product.effects:
		append_text("\n- ")

		add_image(effect.icon, 16, 16)

		append_text(" %s" % effect.name)
