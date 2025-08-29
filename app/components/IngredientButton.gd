class_name IngredientButton
extends TextureButton

enum SLOT {FIRST, SECOND, THIRD, FOURTH}

@export var ingredient_slot: SLOT

@onready var icon: TextureRect = $Icon

func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	EventBus.mixer.ingredient_selector_unset.emit(ingredient_slot)
