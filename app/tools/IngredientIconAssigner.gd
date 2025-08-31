@tool
extends EditorScript

# Configure these paths according to your project structure
const INGREDIENTS_FOLDER = "res://resources/ingredients/"
const ICONS_FOLDER = "res://assets/ingredient-icons/"

func _run():
	print("Starting ingredient icon assignment...")
	
	# Get all .tres files from ingredients folder
	var ingredient_files = get_files_with_extension(INGREDIENTS_FOLDER, ".tres")
	print("Found %d ingredient files" % ingredient_files.size())
	
	# Get all icon files from icons folder
	var icon_files = get_icon_files(ICONS_FOLDER)
	print("Found %d icon files" % icon_files.size())
	
	if ingredient_files.size() > icon_files.size():
		print("Warning: More ingredients than icons available!")
	
	# Shuffle icons to randomize assignment
	# icon_files.shuffle()
	
	# Assign icons to ingredients
	for i in range(min(ingredient_files.size(), icon_files.size())):
		var ingredient_path = ingredient_files[i]
		var icon_path = icon_files[i]
		
		# Load the ingredient resource
		var ingredient = load(ingredient_path) as Ingredient
		if ingredient == null:
			print("Failed to load ingredient: %s" % ingredient_path)
			continue
		
		# Load the icon texture
		var icon_texture = load(icon_path) as Texture2D
		if icon_texture == null:
			print("Failed to load icon: %s" % icon_path)
			continue
		
		# Assign the icon
		ingredient.icon = icon_texture
		
		# Save the resource
		var error = ResourceSaver.save(ingredient, ingredient_path)
		if error != OK:
			print("Failed to save ingredient: %s" % ingredient_path)
		else:
			print("Assigned %s to %s" % [icon_path.get_file(), ingredient_path.get_file()])
	
	print("Icon assignment complete!")

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

func get_icon_files(folder_path: String) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(folder_path)
	
	if dir == null:
		print("Failed to open directory: %s" % folder_path)
		return files
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	# Common image extensions
	var image_extensions = [".png", ".jpg", ".jpeg", ".webp", ".svg"]
	
	while file_name != "":
		if !dir.current_is_dir():
			for ext in image_extensions:
				if file_name.ends_with(ext):
					files.append(folder_path + file_name)
					break
		file_name = dir.get_next()
	
	return files
