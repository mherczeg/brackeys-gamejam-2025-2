class_name IngredientSelectorElement
extends PanelContainer

const EFFECT_LABEL_GROUP: String = "ingredient-selector-effect-label"
const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")
const UNKNOWN_EFFECT_LABEL_SCENE: PackedScene = preload("res://components/UnknownEffectLabel.tscn")

var ingredient: Ingredient
var slot: IngredientButton.SLOT

@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %Name
@onready var effects: HBoxContainer = %Effects
@onready var unknown_effect_label: UnknownEffectLabel
# @onready var description_label: Label = %Description

func _ready() -> void:
	if ingredient:
		icon.texture = ingredient.icon
		name_label.text = ingredient.name
		_render_effect_labels()
		_update_effect_label_visibility()

	EventBus.mixer.ingredient_selector_toggle.connect(_on_selector_opened)
	EventBus.mixer.ingredient_effects_unlocked.connect(_update_effect_label_visibility)

func _on_selector_opened(slot_opened: IngredientButton.SLOT) -> void:
	slot = slot_opened

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:
				_on_pressed()

func _on_pressed() -> void:
	EventBus.mixer.ingredient_selected.emit(slot, ingredient)

func _render_effect_labels() -> void:
	for effect: Effect in ingredient.effects.keys():
		var effect_label: EffectLabel = EFFECT_LABEL_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.add_to_group(EFFECT_LABEL_GROUP)
		effects.add_child(effect_label)

	unknown_effect_label = UNKNOWN_EFFECT_LABEL_SCENE.instantiate()
	effects.add_child(unknown_effect_label)

func _update_effect_label_visibility() -> void:
	var has_unknown: bool = false
	for child: Node in effects.get_children():
		if child is EffectLabel && child.is_in_group(EFFECT_LABEL_GROUP):
			if ingredient.effects[child.effect]:
				child.show()
			else:
				child.hide()
				has_unknown = true

	if has_unknown:
		unknown_effect_label.show()
	else:
		unknown_effect_label.hide()
