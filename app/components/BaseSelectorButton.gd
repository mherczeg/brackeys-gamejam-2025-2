class_name BaseSelectorButton
extends TextureButton

var base: Base

func _ready() -> void:
	if base:
		($Icon as TextureRect).texture = base.icon
		pressed.connect(_on_pressed)

func _on_pressed() -> void:
	EventBus.mixer.base_selected.emit(base)
