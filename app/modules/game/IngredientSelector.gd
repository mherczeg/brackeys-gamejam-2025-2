class_name IngredientSelector
extends Panel

const INGREDIENT_SELECTOR_BUTTON_SCENE: PackedScene = \
	preload("res://modules/mixing-pane/components/IngredientSelectorButton.tscn")
const PRODUCT_TYPE_SELECTOR_BUTTON_SCENE: PackedScene = \
	preload("res://modules/mixing-pane/components/ProductTypeSelectorButton.tscn")

@onready var product_types_container: GridContainer = %ListContainer/ProductTypes
@onready var ingredients_container: VBoxContainer = %ListContainer/Ingredients


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	_create_product_type_selector_elements()
	_create_ingredient_selector_elements()

func _create_ingredient_selector_elements() -> void:
	for ingredient: Ingredient in ResourceManager.ingredients:
		var ingredient_selector_element_instance: IngredientSelectorButton = \
			INGREDIENT_SELECTOR_BUTTON_SCENE.instantiate()
		ingredient_selector_element_instance.ingredient = ingredient
		ingredients_container.add_child(ingredient_selector_element_instance)

func _create_product_type_selector_elements() -> void:
	for product_type: ProductType in ResourceManager.product_types:
		var product_type_selector_element: ProductTypeSelectorButton = \
			PRODUCT_TYPE_SELECTOR_BUTTON_SCENE.instantiate()
		product_type_selector_element.product_type = product_type
		product_types_container.add_child(product_type_selector_element)

func update_button_selection_states(
	selected_ingredients: Dictionary[MixerButtons.SLOT, Ingredient]
) -> void:
	for child: IngredientSelectorButton in ingredients_container.get_children():
		child.update_selection_state(selected_ingredients)
