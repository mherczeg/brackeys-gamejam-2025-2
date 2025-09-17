class_name IngredientLabelIcon
extends TextureRect

var ingredient: Ingredient:
	set(new_ingredient):
		ingredient = new_ingredient
		_apply_ingredient()

func _ready() -> void:
	_apply_ingredient()

func _apply_ingredient() -> void:
	if ingredient:
		texture = ingredient.icon
		tooltip_text = ingredient.name
	else:
		texture = null
		tooltip_text = ""