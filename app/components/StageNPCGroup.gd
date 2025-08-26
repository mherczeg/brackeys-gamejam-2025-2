class_name StageNPCGroup
extends Control

@export var stage: Encounter.STAGE

@onready var stage_npcs: Array[StageNPC] = [
	$StageNPC,
	$StageNPC2,
	$StageNPC3
]

func show_encounter(encounter: Encounter) -> void:
	print(stage)
	var texts: Array[String] = encounter.get_stage_text(stage).values()

	reset_npcs()

	for i: int in texts.size():
		stage_npcs[i].set_text(texts[i])
		stage_npcs[i].show()

	show()


func reset_npcs() -> void:
	for stage_npc: StageNPC in stage_npcs:
		stage_npc.hide()
		stage_npc.set_text("")
