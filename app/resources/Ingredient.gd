class_name Ingredient
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var effects: Dictionary[Effect, bool]

func is_effect_known(effect: Effect) -> bool:
    return effects.has(effect) && effects[effect]