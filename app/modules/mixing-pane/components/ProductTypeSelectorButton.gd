class_name ProductTypeSelectorButton
extends TextureButton

signal disabled_changed

@export var product_type: ProductType

func _ready() -> void:
	texture_normal = product_type.icon
	_update_product_type_availability()
	pressed.connect(_on_pressed)
	EventBus.mixer.product_type_selected.connect(_on_product_type_selected)
	EventBus.player.product_types_available_changed.connect(_update_product_type_availability)

func _on_pressed() -> void:
	EventBus.mixer.product_type_selected.emit(product_type)

func _update_product_type_availability() -> void:
	if Player.product_types.has(product_type):
		show()
	else:
		hide()

func _on_product_type_selected(selected_product_type: ProductType) -> void:
	if product_type == selected_product_type:
		disabled = true
	else:
		disabled = false

	disabled_changed.emit()
