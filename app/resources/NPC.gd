class_name NPC
extends Resource

@export var real_name: String
@export var display_name: String
@export var icon: Texture2D
@export var body_image: Texture2D
@export var likes: Dictionary[Effect, bool]
@export var dislikes: Dictionary[Effect, bool]
@export var allergies: Dictionary[Effect, bool]