class_name CustomerPane
extends Control

signal pressed

@onready var encounter_storybox: EncounterStorybox = %EncounterStorybox


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:
				pressed.emit()
