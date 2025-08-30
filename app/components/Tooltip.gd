class_name TooltipTrigger
extends Control

@export var tooltip_content: Control

func _ready() -> void:
	tooltip_content.hide()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	tooltip_content.show()

func _on_mouse_exited() -> void:
	tooltip_content.hide()
