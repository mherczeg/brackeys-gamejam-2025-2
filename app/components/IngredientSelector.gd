extends ScrollContainer

const INGREDIENTS_PATH: String = "res://resources/ingredients"
const INGREDIENT_SELECTOR_ELEMENT_SCENE: PackedScene = preload("res://components/IngredientSelectorElement.tscn")

var ingredient_db: Array[Ingredient] = []

@onready var list_container: VBoxContainer = $ListContainer

func _init() -> void:
	_load_all_ingredients()

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	for ingredient: Ingredient in ingredient_db:
		var ingredient_selector_element_instance: IngredientSelectorElement = \
			INGREDIENT_SELECTOR_ELEMENT_SCENE.instantiate()
		ingredient_selector_element_instance.ingredient = ingredient
		list_container.add_child(ingredient_selector_element_instance)


func _load_all_ingredients() -> void:
	var dir: DirAccess = DirAccess.open(INGREDIENTS_PATH)
	if dir:
		for file_name: String in dir.get_files():
			if file_name.ends_with(".tres"):
				var resource: Resource = load(INGREDIENTS_PATH.path_join(file_name))
				if resource is Ingredient:
					ingredient_db.append(resource)
