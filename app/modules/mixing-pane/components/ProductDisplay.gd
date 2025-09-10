class_name ProductDisplay
extends VBoxContainer

const EFFECT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/EffectLabelIcon.tscn")
const INGREDIENT_LABEL_ICON_SCENE: PackedScene = preload("res://modules/shared/IngredientLabelIcon.tscn")

@onready var effects: HBoxContainer = $Effects
@onready var product_type_icon: TextureRect = $ProductTypeIconBg/ProductTypeIcon
@onready var product_type_label: Label = $ProductTypeLabel
@onready var effects_discovered: Label = $EffectsDiscovered
@onready var discovered_ingredients: HBoxContainer = $EffectsDiscovered/IngredientList


func _ready() -> void:
	for effect: Effect in ResourceManager.effects:
		var effect_label: EffectLabelIcon = EFFECT_LABEL_ICON_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.hide()
		effects.add_child(effect_label)

func show_product(product: MixedProduct) -> void:
	product_type_label.text = "You have made a %s!" % product.product_type.name
	product_type_icon.texture = product.product_type.icon

	for effect_label: EffectLabelIcon in effects.get_children():
		if product.effects.has(effect_label.effect):
			effect_label.show()
		else:
			effect_label.hide()

	if product.unlocked_effects.size():
		for child: Node in discovered_ingredients.get_children():
			child.free()

		for ingredient: Ingredient in product.unlocked_effects.keys():
			var icon: IngredientLabelIcon = INGREDIENT_LABEL_ICON_SCENE.instantiate()
			icon.ingredient = ingredient
			discovered_ingredients.add_child(icon)
		effects_discovered.show()
	else:
		effects_discovered.hide()

	show()
