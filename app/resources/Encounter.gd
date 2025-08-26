class_name Encounter
extends Resource

enum STAGE {FIRST, SECOND, THIRD}

@export var order: Dictionary[NPC, Product] = {}
@export var stage_1_text: Dictionary[NPC, String] = {}
@export var stage_2_text: Dictionary[NPC, String] = {}
@export var stage_3_text: Dictionary[NPC, String] = {}

var customers: Array[NPC]:
    get():
        return order.keys()

func get_stage_text(stage: STAGE) -> Dictionary[NPC, String]:
    match stage:
        STAGE.FIRST:
            return stage_1_text
        STAGE.SECOND:
            return stage_2_text
        STAGE.THIRD:
            return stage_3_text

    return {}