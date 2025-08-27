class_name ProductDisplay
extends VBoxContainer

const EFFECT_LABEL_SCENE: PackedScene = preload("res://components/EffectLabel.tscn")

@onready var effects: VBoxContainer = $Effects
@onready var base_icon: TextureRect = $BaseIcon
@onready var base_label: Label = $BaseIcon/BaseLabel


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
	show()
