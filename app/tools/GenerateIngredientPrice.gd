@tool
extends EditorScript

# Configure this path according to your project structure
const INGREDIENTS_FOLDER = "res://resources/ingredients/"

func _run():
	print("Starting ingredient price assignment...")
	
	# Get all .tres files from ingredients folder
	var ingredient_files = get_files_with_extension(INGREDIENTS_FOLDER, ".tres")
	print("Found %d ingredient files" % ingredient_files.size())
	
	# Assign random prices to ingredients
	for ingredient_path in ingredient_files:
		# Load the ingredient resource
		var ingredient = load(ingredient_path) as Ingredient
		if ingredient == null:
			print("Failed to load ingredient: %s" % ingredient_path)
			continue
		
		# Generate random price between 0.1 and 0.9
		var random_price = randf_range(0.1, 0.9)
		ingredient.price = random_price
		
		# Save the resource
		var error = ResourceSaver.save(ingredient, ingredient_path)
		if error != OK:
			print("Failed to save ingredient: %s" % ingredient_path)
		else:
			print("Set price %.2f for %s" % [random_price, ingredient_path.get_file()])
	
	print("Price assignment complete!")

func get_files_with_extension(folder_path: String, extension: String) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(folder_path)
	
	if dir == null:
		print("Failed to open directory: %s" % folder_path)
		return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir() && file_name.ends_with(extension):
			files.append(folder_path + file_name)
		file_name = dir.get_next()
	
	return files
