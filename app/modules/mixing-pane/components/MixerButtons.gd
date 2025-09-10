class_name MixerButtons
extends HBoxContainer

enum SLOT {FIRST, SECOND, THIRD, FOURTH}

@onready var selected_product_type: ProductTypeButton = $ProductTypeButton
@onready var slot_buttons: Dictionary[SLOT, IngredientButton] = {
	SLOT.FIRST: $IngredientButton1,
	SLOT.SECOND: $IngredientButton2,
	SLOT.THIRD: $IngredientButton3,
	SLOT.FOURTH: $IngredientButton4
}

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	_connect_signals()

func _connect_signals() -> void:
	for slot: SLOT in slot_buttons.keys():
		slot_buttons[slot].pressed.connect(_on_mixer_button_pressed.bind(slot))

func get_slot_button(slot: SLOT) -> IngredientButton:
	return slot_buttons[slot]

func _update_product_type_icon(product_type: ProductType) -> void:
	var icon: Texture2D = null
	if product_type != null:
		icon = product_type.icon
	selected_product_type.icon.texture = icon

func _update_ingredient_icons(ingredients: Dictionary[SLOT, Ingredient]) -> void:
	for slot: SLOT in slot_buttons.keys():
		_update_ingredient_icon(ingredients, slot)

func _update_ingredient_icon(ingredients: Dictionary[SLOT, Ingredient], slot: SLOT) -> void:
	var icon: Texture2D = null
	if ingredients.has(slot):
		icon = ingredients[slot].icon
	slot_buttons[slot].icon.texture = icon

func _on_mixer_button_pressed(slot: SLOT) -> void:
	EventBus.mixer.ingredient_selector_slot_cleared.emit(slot)

func update_icons(
	product_type: ProductType,
	ingredients: Dictionary[MixerButtons.SLOT, Ingredient]
) -> void:
	_update_product_type_icon(product_type)
	_update_ingredient_icons(ingredients)
