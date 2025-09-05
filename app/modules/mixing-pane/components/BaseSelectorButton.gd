class_name BaseSelectorButton
extends TextureButton

signal disabled_changed

@export var base: Base

func _ready() -> void:
	texture_normal = base.icon
	_update_base_availability()
	pressed.connect(_on_pressed)
	EventBus.mixer.base_selected.connect(_on_base_selected)
	EventBus.player.bases_available_changed.connect(_update_base_availability)

func _on_pressed() -> void:
	EventBus.mixer.base_selected.emit(base)

func _update_base_availability() -> void:
	if Player.bases.has(base):
		show()
	else:
		hide()

func _on_base_selected(selected_base: Base) -> void:
	if base == selected_base:
		disabled = true
	else:
		disabled = false

	disabled_changed.emit()
