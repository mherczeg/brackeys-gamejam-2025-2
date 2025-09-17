class_name IngredientSelectorButton
extends TextureButton

signal disabled_changed

const EFFECT_LABEL_ICON_SIZE: Vector2i = Vector2i(16, 16)
const EFFECT_LABEL_GROUP: String = "ingredient-selector-effects-label"
const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const UNKNOWN_EFFECT_LABEL_SCENE: PackedScene = preload("res://modules/shared/UnknownEffectLabel.tscn")

@export var ingredient: Ingredient
var slot: MixerButtons.SLOT
var _is_selected_for_mixture: bool = false
var _unknown_effect_label: UnknownEffectLabel

@onready var inventory_label: Label = $InventoryLabel
@onready var ingredient_name: Label = $MarginContainer/VBoxContainer/Name
@onready var effect_list: HBoxContainer = $MarginContainer/VBoxContainer/EffectList

func _ready() -> void:
	if ingredient:
		_initialize_button()
	_connect_signals()

func _set_ingredient(value: Ingredient) -> void:
	ingredient = value
	if is_node_ready():
		_initialize_button()

func _initialize_button() -> void:
	texture_normal = ingredient.icon
	ingredient_name.text = ingredient.name
	_setup_effect_labels()
	_update_availability()

func _connect_signals() -> void:
	EventBus.player.ingredient_stock_changed.connect(_on_ingredient_stock_changed)
	EventBus.mixer.ingredient_effects_unlocked.connect(_on_ingredient_effects_unlocked)

func update_selection_state(
	selected_ingredients: Dictionary[MixerButtons.SLOT, Ingredient]
) -> void:
	_is_selected_for_mixture = selected_ingredients.values().has(ingredient)
	_update_availability()

func _get_ingredient_count() -> int:
	return Player.inventory.get_ingredient_amount(ingredient)

func _update_availability() -> void:
	var ingredient_count: int = _get_ingredient_count()

	_update_inventory_display(ingredient_count)
	_update_button_state(ingredient_count)

	disabled_changed.emit()

func _update_inventory_display(count: int) -> void:
	inventory_label.text = "%d" % count
	visible = count > 0

func _update_button_state(count: int) -> void:
	disabled = count <= 0 or _is_selected_for_mixture

func _setup_effect_labels() -> void:
	_clear_effect_labels()
	_create_effect_labels()
	_create_unknown_effect_label()
	_update_effect_visibility()

func _clear_effect_labels() -> void:
	for child: Node in effect_list.get_children():
		child.queue_free()

func _create_effect_labels() -> void:
	for effect: Effect in ingredient.effects:
		effect_list.add_child(_create_effect_label(effect))

func _create_effect_label(effect: Effect) -> EffectLabelIcon:
	var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
	effect_label.effect = effect
	effect_label.custom_minimum_size = EFFECT_LABEL_ICON_SIZE
	effect_label.add_to_group(EFFECT_LABEL_GROUP)
	effect_label.hide()
	return effect_label

func _create_unknown_effect_label() -> void:
	_unknown_effect_label = UNKNOWN_EFFECT_LABEL_SCENE.instantiate()
	_unknown_effect_label.hide()
	effect_list.add_child(_unknown_effect_label)

func _update_effect_visibility() -> void:
	var has_unknown_effects: bool = false

	for node: Node in effect_list.get_children():
		if node.is_in_group(EFFECT_LABEL_GROUP):
			var effect_label: EffectLabelIcon = node
			var is_known: bool = ingredient.is_effect_known((effect_label).effect)
			effect_label.visible = is_known
			if !is_known:
				has_unknown_effects = true

	_unknown_effect_label.visible = has_unknown_effects

func _on_ingredient_stock_changed(changed_ingredient: Ingredient) -> void:
	if changed_ingredient == ingredient:
		_update_availability()

func _on_ingredient_effects_unlocked() -> void:
	_update_effect_visibility()
