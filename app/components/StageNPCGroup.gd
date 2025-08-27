class_name StageNPCGroup
extends Control

signal encounter_complete


@export var stage: Encounter.STAGE

var _npc_with_interaciton: int = 0
@onready var stage_npcs: Array[StageNPC] = [
	$StageNPC,
	$StageNPC2,
	$StageNPC3
]

func show_encounter(encounter: Encounter) -> Signal:
	var texts: Array[String] = encounter.get_stage_text(stage).values()
	var npc_count: int = encounter.get_stage_text(stage).size()
	_reset_npcs()
	show()
	_set_npc_visibility(npc_count)
	_process_npc_interactions(texts)

	return encounter_complete

func _set_npc_visibility(npc_count: int) -> void:
	for i: int in npc_count:
		stage_npcs[i].activate_for_interaction()

func _process_npc_interactions(texts: Array[String], _current_npc: int = 0) -> void:
	if _current_npc >= texts.size():
		encounter_complete.emit()
		return

	await stage_npcs[_current_npc].display_text(texts[_current_npc])

	_process_npc_interactions(texts, _current_npc + 1)

func _on_npc_done() -> void:
	_npc_with_interaciton -= 1
	if _npc_with_interaciton == 0:
		encounter_complete.emit()

func _reset_npcs() -> void:
	for stage_npc: StageNPC in stage_npcs:
		stage_npc.hide()
		stage_npc.clear_text()
		stage_npc.clear_interaction()

func clear_text() -> void:
	for stage_npc: StageNPC in stage_npcs:
		stage_npc.clear_text()
		stage_npc.clear_interaction()

func display_npc_text(npc_index: int, text: String) -> Signal:
	stage_npcs[npc_index].textbox.is_active_for_interaction = true
	var display: Signal = stage_npcs[npc_index].display_text(text)
	display.connect(
		func() -> void: stage_npcs[npc_index].textbox.is_active_for_interaction = false,
		ConnectFlags.CONNECT_ONE_SHOT
	)
	return display
