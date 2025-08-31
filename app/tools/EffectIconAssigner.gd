@tool
extends EditorScript

# Configure these paths according to your project structure
const EFFECTS_FOLDER = "res://resources/effects/"
const ICONS_FOLDER = "res://assets/runes-icon/"

func _run():
	print("Starting effect icon assignment...")
	
	# Get all .tres files from effects folder
	var effect_files = get_files_with_extension(EFFECTS_FOLDER, ".tres")
	print("Found %d effect files" % effect_files.size())
	
	# Get all icon files from icons folder
	var icon_files = get_icon_files(ICONS_FOLDER)
	print("Found %d icon files" % icon_files.size())
	
	if effect_files.size() > icon_files.size():
		print("Warning: More effects than icons available!")
	
	# Shuffle icons to randomize assignment
	icon_files.shuffle()
	
	# Assign icons to effects
	for i in range(min(effect_files.size(), icon_files.size())):
		var effect_path = effect_files[i]
		var icon_path = icon_files[i]
		
		# Load the effect resource
		var effect = load(effect_path) as Effect
		if effect == null:
			print("Failed to load effect: %s" % effect_path)
			continue
		
		# Load the icon texture
		var icon_texture = load(icon_path) as Texture2D
		if icon_texture == null:
			print("Failed to load icon: %s" % icon_path)
			continue
		
		# Assign the icon
		effect.icon = icon_texture
		
		# Save the resource
		var error = ResourceSaver.save(effect, effect_path)
		if error != OK:
			print("Failed to save effect: %s" % effect_path)
		else:
			print("Assigned %s to %s" % [icon_path.get_file(), effect_path.get_file()])
	
	print("Effect icon assignment complete!")

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
