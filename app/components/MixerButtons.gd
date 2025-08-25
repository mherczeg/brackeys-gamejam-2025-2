class_name MixerButtons
extends HBoxContainer

@onready var selected_base_icon: TextureRect = $BaseButton/Icon
@onready var slot_buttons: Dictionary[IngredientButton.SLOT, IngredientButton] = {
	IngredientButton.SLOT.FIRST: $IngredientButton1,
	IngredientButton.SLOT.SECOND: $IngredientButton2,
	IngredientButton.SLOT.THIRD: $IngredientButton3,
	IngredientButton.SLOT.FOURTH: $IngredientButton4
}

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP

func get_slot_button(slot: IngredientButton.SLOT) -> IngredientButton:
	return slot_buttons[slot]

func update_base_icon(icon: Texture2D) -> void:
	selected_base_icon.texture = icon

func update_slot_icon(slot: IngredientButton.SLOT, icon: Texture2D) -> void:
	slot_buttons[slot].icon.texture = icon
