extends Node

var product_types: Array[ProductType] = []
var effects: Array[Effect] = []
var encounters: Array[Encounter] = []
var ingredients: Array[Ingredient] = []
var npcs: Array[NPC] = []
var products: Array[Product] = []

func _ready() -> void:
	product_types.append_array(_load_resources(ResourceList.product_type_paths))
	effects.append_array(_load_resources(ResourceList.effects_paths))
	encounters.append_array(_load_resources(ResourceList.encounters_paths))
	ingredients.append_array(_load_resources(ResourceList.ingredients_paths))
	npcs.append_array(_load_resources(ResourceList.npcs_paths))
	products.append_array(_load_resources(ResourceList.products_paths))


func _load_resources(paths: Array[String]) -> Array:
	var resources: Array = []
	for path: String in paths:
		var resource: Variant = load(path)
		if resource:
			resources.append(resource)
		else:
			printerr("ResourceManager: Failed to load resource at path: %s" % path)
	return resources
