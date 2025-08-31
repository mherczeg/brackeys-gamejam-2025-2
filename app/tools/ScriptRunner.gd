@tool
extends EditorScript

func _run():
	var generator = TresGenerator.new()
	# generator.generate("res://data/bases.json", "res://resources/generated/bases")
	# generator.generate("res://data/effects.json", "res://resources/generated/effects")
	generator.generate("res://data/ingredients.json", "res://resources/generated/ingredients")
	#generator.generate("res://data/products.json", "res://resources/generated/products")
