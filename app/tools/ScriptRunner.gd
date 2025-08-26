@tool
extends EditorScript

func _run():
	var generator = TresGenerator.new()
	generator.generate("res://data/my_resources.json", "res://resources/generated")
