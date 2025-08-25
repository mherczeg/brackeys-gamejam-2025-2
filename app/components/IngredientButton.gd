class_name IngredientButton
extends TextureButton

enum SLOT {FIRST, SECOND, THIRD, FOURTH}

@export var ingredient_slot: SLOT

@onready var icon: TextureRect = $Icon

func _ready() -> void:
	pressed.connect(_on_pressed)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_RIGHT:
				_on_right_clicked()

func _on_pressed() -> void:
	EventBus.mixer.ingredient_selector_toggle.emit(ingredient_slot)

func _on_right_clicked() -> void:
	EventBus.mixer.ingredient_selector_unset.emit(ingredient_slot)