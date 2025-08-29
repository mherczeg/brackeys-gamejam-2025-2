class_name IngredientSelector
extends ScrollContainer

const INGREDIENT_SELECTOR_BUTTON_SCENE: PackedScene = preload("res://components/IngredientSelectorButton.tscn")
const BASE_SELECTOR_BUTTON_SCENE: PackedScene = preload("res://components/BaseSelectorButton.tscn")

@onready var bases_container: GridContainer = %ListContainer/Bases
@onready var ingredients_container: GridContainer = %ListContainer/Ingredients


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	_render_base_selector_elements()
	_render_ingredient_selector_elements()

func _render_ingredient_selector_elements() -> void:
	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_selector_element_instance: IngredientSelectorButton = \
			INGREDIENT_SELECTOR_BUTTON_SCENE.instantiate()
		ingredient_selector_element_instance.ingredient = ingredient
		ingredients_container.add_child(ingredient_selector_element_instance)

func _render_base_selector_elements() -> void:
	for base: Base in ResourceManager.bases:
		var base_selector_element: BaseSelectorButton = \
			BASE_SELECTOR_BUTTON_SCENE.instantiate()
		base_selector_element.base = base
		bases_container.add_child(base_selector_element)
