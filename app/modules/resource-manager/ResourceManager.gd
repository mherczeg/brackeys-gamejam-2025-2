extends Node

var bases: Array[Base] = []
var effects: Array[Effect] = []
var encounters: Array[Encounter] = []
var ingredients: Array[Ingredient] = []
var npcs: Array[NPC] = []
var products: Array[Product] = []

func _ready() -> void:
	bases.append_array(_load_resources(ResourceList.bases_paths))
	effects.append_array(_load_resources(ResourceList.effects_paths))
	encounters.append_array(_load_resources(ResourceList.encounters_paths))
	ingredients.append_array(_load_resources(ResourceList.ingredients_paths))
	npcs.append_array(_load_resources(ResourceList.npcs_paths))
	products.append_array(_load_resources(ResourceList.products_paths))


func _load_resources(paths: Array[String]) -> Array:
	var resources: Array = []
	for path in paths:
		var resource = load(path)
		if resource:
			resources.append(resource)
		else:
			printerr("ResourceManager: Failed to load resource at path: %s" % path)
	return resources
