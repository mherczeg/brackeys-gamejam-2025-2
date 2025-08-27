class_name IngredientSelector
extends ScrollContainer

const INGREDIENTS_PATH: String = "res://resources/ingredients"
const INGREDIENT_SELECTOR_ELEMENT_SCENE: PackedScene = preload("res://components/IngredientSelectorElement.tscn")

@onready var list_container: VBoxContainer = $ListContainer


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	_render_ingredient_selector_elements()

func open(used_ingredients: Array[Ingredient]) -> void:
	for child: IngredientSelectorElement in list_container.get_children():
		if child is IngredientSelectorElement:
			if child.is_unavailable(used_ingredients):
				child.hide()
			else:
				child.show()
	show()

func _render_ingredient_selector_elements() -> void:
	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_selector_element_instance: IngredientSelectorElement = \
			INGREDIENT_SELECTOR_ELEMENT_SCENE.instantiate()
		ingredient_selector_element_instance.ingredient = ingredient
		list_container.add_child(ingredient_selector_element_instance)
