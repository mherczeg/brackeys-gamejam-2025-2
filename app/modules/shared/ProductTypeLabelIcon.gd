class_name ProductTypeLabelIcon
extends TextureRect

var product_type: ProductType:
	set(new_product_type):
		product_type = new_product_type
		_apply_product_type()

func _ready() -> void:
	_apply_product_type()

func _apply_product_type() -> void:
	if product_type:
		texture = product_type.icon
		tooltip_text = product_type.name
	else:
		texture = null
		tooltip_text = ""