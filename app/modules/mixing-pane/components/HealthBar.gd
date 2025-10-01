class_name HealthBar
extends ProgressBar

@export var damage_sounds: Array[AudioStream] = []

func _ready() -> void:
	EventBus.player.health_changed.connect(_on_player_health_changed)
	value = Player.health

func _on_player_health_changed(new_health: int, old_health: int) -> void:
	value = new_health

	if new_health < old_health:
		var damage_sound: AudioStream = damage_sounds.pick_random()
		EventBus.ui.play_sound_effect.emit(damage_sound)
