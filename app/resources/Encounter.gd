class_name Encounter
extends Resource

@export var order: Dictionary[NPC, Product] = {}
@export var stage_1_text: Dictionary[NPC, String] = {}
@export var stage_2_text: Dictionary[NPC, String] = {}
@export var stage_3_text: Dictionary[NPC, String] = {}

var customers: Array[NPC]:
    get():
        return order.keys()