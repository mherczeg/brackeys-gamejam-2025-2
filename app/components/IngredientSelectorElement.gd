class_name IngredientSelectorElement
extends PanelContainer

const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")

var ingredient: Ingredient
var slot: IngredientButton.SLOT

@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %Name
@onready var effects: HBoxContainer = %Effects
# @onready var description_label: Label = %Description

func _ready() -> void:
	if ingredient:
		icon.texture = ingredient.icon
		name_label.text = ingredient.name
		for effect: Effect in ingredient.effects:
			var effect_label: EffectLabel = EFFECT_LABEL_SCENE.instantiate()
			effect_label.effect = effect
			effects.add_child(effect_label)

	EventBus.mixer.ingredient_selector_toggle.connect(_on_selector_opened)

func _on_selector_opened(slot_opened: IngredientButton.SLOT) -> void:
	slot = slot_opened

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:
				_on_pressed()

func _on_pressed() -> void:
	EventBus.mixer.ingredient_selected.emit(slot, ingredient)
