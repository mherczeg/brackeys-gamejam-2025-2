extends HBoxContainer

const PRODUCT_TYPE_SELECTOR_BUTTON_SCENE: PackedScene = \
	preload("res://modules/mixing-pane/components/ProductTypeSelectorButton.tscn")


func _ready() -> void:
	_render_product_type_buttons()
	EventBus.player.product_types_available_changed.connect(_on_product_types_available_changed)


func _render_product_type_buttons() -> void:
	for product_type: ProductType in Player.inventory.get_available_product_types():
		var button_instance: ProductTypeSelectorButton = PRODUCT_TYPE_SELECTOR_BUTTON_SCENE.instantiate()
		button_instance.product_type = product_type
		add_child(button_instance)

func _on_product_types_available_changed() -> void:
	Utils.clear_children(self)
	_render_product_type_buttons()
