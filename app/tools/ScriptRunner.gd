@tool
extends EditorScript

func _run():
	var generator = TresGenerator.new()
	# generator.generate("res://data/product-types.json", "res://resources/generated/product-types")
	# generator.generate("res://data/effects.json", "res://resources/generated/effects")
	generator.generate("res://data/ingredients.json", "res://resources/generated/ingredients")
	#generator.generate("res://data/products.json", "res://resources/generated/products")
