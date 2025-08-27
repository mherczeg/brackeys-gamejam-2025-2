extends HBoxContainer

const BASE_SELECTOR_BUTTON_SCENE: PackedScene = preload("res://components/BaseSelectorButton.tscn")


func _ready() -> void:
	for base: Base in Player.bases:
		var button_instance: BaseSelectorButton = BASE_SELECTOR_BUTTON_SCENE.instantiate()
		button_instance.base = base
		add_child(button_instance)
