class_name Game
extends Node2D

@onready var customer_pane: CustomerPane = %CustomerPane

func _ready() -> void:
	EventBus.debug.render_encounter_stage.connect(render_encounter_stage)


func render_encounter_stage(encounter: Encounter, stage: Encounter.STAGE) -> void:
	customer_pane.encounter_storybox.render_story_step(encounter, stage)
