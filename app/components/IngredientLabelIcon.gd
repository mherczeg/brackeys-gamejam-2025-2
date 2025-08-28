class_name IngredientLabelIcon
extends TextureRect

var ingredient: Ingredient

func _ready() -> void:
    if ingredient:
        texture = ingredient.icon