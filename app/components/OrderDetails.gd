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

	append_text(" ")

	push_bold()

	append_text(product.name)

	pop()

	append_text(".\n(Recipe: ")

	add_image(product.base.icon, 16, 16)

	append_text(" ")

	push_bold()

	append_text(product.base.name)

	pop()

	for effect: Effect in product.effects:
		append_text(", ")

		add_image(effect.icon, 16, 16)

		append_text(" ")

		push_bold()

		append_text(effect.name)

		pop()

	append_text(")")
