class_name ProductDisplay
extends VBoxContainer

const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")

@onready var effects: VBoxContainer = $Effects
@onready var base_icon: TextureRect = $BaseIcon
@onready var base_label: Label = $BaseIcon/BaseLabel
@onready var effects_discovered: Label = $EffectsDiscovered
@onready var discovered_ingredients: HBoxContainer = $EffectsDiscovered/IngredientList


func _ready() -> void:
	for effect: Effect in ResourceManager.effects:
		var effect_label: EffectLabel = EFFECT_LABEL_SCENE.instantiate()
		effect_label.effect = effect
		effect_label.hide()
		effects.add_child(effect_label)

func show_product(product: MixedProduct) -> void:
	base_label.text = "You have made a %s!" % product.base.name
	base_icon.texture = product.base.icon

	for effect_label: EffectLabel in effects.get_children():
		if product.effects.has(effect_label.effect):
			effect_label.show()
		else:
			effect_label.hide()

	if product.unlocked_effects.size():
		for child: Node in discovered_ingredients.get_children():
			child.free()

		for ingredient: Ingredient in product.unlocked_effects.keys():
			var icon: TextureRect = TextureRect.new()
			icon.texture = ingredient.icon
			discovered_ingredients.add_child(icon)
		effects_discovered.show()
	else:
		effects_discovered.hide()

	show()
