class_name UIEvents
extends Node

signal show_npc_info(npc: NPC, position: Vector2)
signal hide_npc_info
signal toggle_npc_pane
signal play_sound_effect(sound_effect: AudioStream, stream_settings: Dictionary)
signal play_sound_effect_complete(sound_effect: AudioStream)