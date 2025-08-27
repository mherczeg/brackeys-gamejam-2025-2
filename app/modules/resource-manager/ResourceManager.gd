extends Node

var bases: Array[Base]
var effects: Array[Effect]
var encounters: Array[Encounter]
var ingredients: Array[Ingredient]
var npcs: Array[NPC]
var products: Array[Product]
func _ready() -> void:
	bases = _load_bases()
	effects = _load_effects()
	encounters = _load_encounters()
	ingredients = _load_ingredients()
	npcs = _load_npcs()
	products = _load_products()


func _load_bases() -> Array[Base]:
	var untyped_bases: Array = _load_resources_from_dir("res://resources/bases/")
	var typed_bases: Array[Base] = []
	for base: Base in untyped_bases:
		if base is Base:
			typed_bases.append(base)

	return typed_bases

func _load_effects() -> Array[Effect]:
	var untyped_effects: Array = _load_resources_from_dir("res://resources/effects/")
	var typed_effects: Array[Effect] = []
	for effect: Effect in untyped_effects:
		if effect is Effect:
			typed_effects.append(effect)
	return typed_effects

func _load_encounters() -> Array[Encounter]:
	var untyped_encounters: Array = _load_resources_from_dir("res://resources/encounters/")
	var typed_encounters: Array[Encounter] = []
	for encounter: Encounter in untyped_encounters:
		if encounter is Encounter:
			typed_encounters.append(encounter)
	return typed_encounters

func _load_ingredients() -> Array[Ingredient]:
	var untyped_ingredients: Array = _load_resources_from_dir("res://resources/ingredients/")
	var typed_ingredients: Array[Ingredient] = []
	for ingredient: Ingredient in untyped_ingredients:
		if ingredient is Ingredient:
			typed_ingredients.append(ingredient)
	return typed_ingredients

func _load_npcs() -> Array[NPC]:
	var untyped_npcs: Array = _load_resources_from_dir("res://resources/npcs/")
	var typed_npcs: Array[NPC] = []
	for npc: NPC in untyped_npcs:
		if npc is NPC:
			typed_npcs.append(npc)
	return typed_npcs

func _load_products() -> Array[Product]:
	var untyped_products: Array = _load_resources_from_dir("res://resources/products/")
	var typed_products: Array[Product] = []
	for product: Product in untyped_products:
		if product is Product:
			typed_products.append(product)
	return typed_products

func _load_resources_from_dir(path: String) -> Array:
	var resources: Array = []
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var resource: Resource = load(path.path_join(file_name))
				if resource:
					resources.append(resource)
			file_name = dir.get_next()
	else:
		printerr("ResourceManager: Could not open directory at path: %s" % path)

	return resources
