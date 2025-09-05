class_name MixerButtons
extends HBoxContainer

enum SLOT {FIRST, SECOND, THIRD, FOURTH}

@onready var selected_base_icon: TextureRect = $BaseButton/Icon
@onready var slot_buttons: Dictionary[MixerButtons.SLOT, IngredientButton] = {
	SLOT.FIRST: $IngredientButton1,
	SLOT.SECOND: $IngredientButton2,
	SLOT.THIRD: $IngredientButton3,
	SLOT.FOURTH: $IngredientButton4
}

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP

	for slot: MixerButtons.SLOT in slot_buttons.keys():
		slot_buttons[slot].pressed.connect(_on_mixer_button_pressed.bind(slot))

func get_slot_button(slot: MixerButtons.SLOT) -> IngredientButton:
	return slot_buttons[slot]

func update_base_icon(icon: Texture2D) -> void:
	selected_base_icon.texture = icon

func update_slot_icon(slot: SLOT, icon: Texture2D) -> void:
	slot_buttons[slot].icon.texture = icon

func _on_mixer_button_pressed(slot: SLOT) -> void:
	EventBus.mixer.ingredient_selector_unset.emit(slot)
