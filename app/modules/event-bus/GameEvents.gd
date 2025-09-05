class_name GameEvents
extends RefCounted


signal start_encounter(encounter: Encounter)
signal show_reaction(npc_index: int, text: String)
signal encounter_evaluate_stage_started