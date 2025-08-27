class_name Encounter
extends Resource

enum STAGE {FIRST, SECOND, THIRD, LIKE, DISLIKE, FAILURE}

@export var order: Dictionary[NPC, Product] = {}
@export var stage_1_text: Dictionary[NPC, String] = {}
@export var stage_2_text: Dictionary[NPC, String] = {}
@export var stage_3_text: Dictionary[NPC, String] = {}
@export var like_text: Dictionary[NPC, String] = {}
@export var dislike_text: Dictionary[NPC, String] = {}
@export var failure_text: Dictionary[NPC, String] = {}

var customers: Array[NPC]:
    get():
        return order.keys()

func get_stage_text(stage: STAGE) -> Dictionary[NPC, String]:
    var text: Dictionary[NPC, String] = {}
    match stage:
        STAGE.FIRST:
            text = stage_1_text
        STAGE.SECOND:
            text = stage_2_text
        STAGE.THIRD:
            text = stage_3_text
        STAGE.LIKE:
            text = like_text
        STAGE.DISLIKE:
            text = dislike_text
        STAGE.FAILURE:
            text = failure_text

    return text