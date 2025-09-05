class_name EncounterStorybox
extends Node

const STAGE_NPC_GROUP: String = "stage-npc-group"

@export var encounter: Encounter
@export var stage: Encounter.STAGE

@onready var stage_group_nodes: Dictionary[Encounter.STAGE, StageNPCGroup] = {
	Encounter.STAGE.FIRST: $FirstStageGroup,
	Encounter.STAGE.SECOND: $SecondStageGroup,
	Encounter.STAGE.THIRD: $ThirdStageGroup,
}

func _ready() -> void:
	_reset_group_visibility()


func render_story_step(new_encounter: Encounter, new_stage: Encounter.STAGE) -> Signal:
	encounter = new_encounter
	stage = new_stage
	return _render()

func clear_stage_text() -> void:
	stage_group_nodes[stage].clear_text()

func render_single_message(npc_index: int, text: String) -> Signal:
	return stage_group_nodes[stage].display_npc_text(npc_index, text)

func clear() -> void:
	_reset_group_visibility()

func _render() -> Signal:
	_reset_group_visibility()
	return stage_group_nodes[stage].show_encounter(encounter)

func _reset_group_visibility() -> void:
	for stage_group_node: StageNPCGroup in stage_group_nodes.values():
		stage_group_node.hide()
