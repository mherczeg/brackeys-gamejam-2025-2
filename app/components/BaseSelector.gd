extends HBoxContainer

const BASE_SELECTOR_BUTTON_SCENE: PackedScene = preload("res://components/BaseSelectorButton.tscn")


func _ready() -> void:
	_render_base_buttons()
	EventBus.player.bases_available_changed.connect(_on_bases_available_changed)


func _render_base_buttons() -> void:
	for base: Base in Player.bases:
		var button_instance: BaseSelectorButton = BASE_SELECTOR_BUTTON_SCENE.instantiate()
		button_instance.base = base
		add_child(button_instance)

func _reset_items() -> void:
	for child: Node in get_children():
		child.free()

func _on_bases_available_changed() -> void:
	_reset_items()
	_render_base_buttons()
