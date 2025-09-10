class_name IngredientSelector
extends ScrollContainer

const INGREDIENT_SELECTOR_BUTTON_SCENE: PackedScene = \
	preload("res://modules/mixing-pane/components/IngredientSelectorButton.tscn")
const PRODUCT_TYPE_SELECTOR_BUTTON_SCENE: PackedScene = \
	preload("res://modules/mixing-pane/components/ProductTypeSelectorButton.tscn")

@onready var product_types_container: GridContainer = %ListContainer/ProductTypes
@onready var ingredients_container: VBoxContainer = %ListContainer/Ingredients


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	_render_product_type_selector_elements()
	_render_ingredient_selector_elements()

func _render_ingredient_selector_elements() -> void:
	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_selector_element_instance: IngredientSelectorButton = \
			INGREDIENT_SELECTOR_BUTTON_SCENE.instantiate()
		ingredient_selector_element_instance.ingredient = ingredient
		ingredients_container.add_child(ingredient_selector_element_instance)

func _render_product_type_selector_elements() -> void:
	for product_type: ProductType in ResourceManager.product_types:
		var product_type_selector_element: ProductTypeSelectorButton = \
			PRODUCT_TYPE_SELECTOR_BUTTON_SCENE.instantiate()
		product_type_selector_element.product_type = product_type
		product_types_container.add_child(product_type_selector_element)
