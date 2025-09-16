class_name Textbox
extends Label

signal display_complete

const DEFAULT_DISPLAY_TIME: float = 0.02
const PITCH_VARIATION_MIN: float = 0.8
const PITCH_VARIATION_MAX: float = 1.2
const ESTIMATED_LINE_HEIGHT: int = 19
const VOWELS: String = "aeiouAEIOU"

@export var consonant_sound: AudioStream
@export var vowel_sound: AudioStream
@export var estimated_line_char_length: int = 40
var text_to_display_length: int = 0
var is_active_for_interaction: bool = false
var fast_forward: bool = false
var _text_to_display: String = ""
var _current_voice_pair: Array[AudioStream]
var _letter_index: int = 0

@onready var _display_timer: Timer = $DisplayTimer
@onready var _voice: AudioStreamPlayer2D = $Voice

func _ready() -> void:
	_display_timer.timeout.connect(_on_display_timer_timeout)
	_setup_initial_state()

func _setup_initial_state() -> void:
	text = ""
	_letter_index = 0
	is_active_for_interaction = false

func clear_text() -> void:
	_stop_display()
	text = ""

func clear_display() -> void:
	is_active_for_interaction = false
	fast_forward = false

func prepare_size_for_text(new_text: String) -> void:
	var lines: int = _calculate_line_count(new_text)
	custom_minimum_size.y = lines * ESTIMATED_LINE_HEIGHT
	show()

func display_text(new_text: String) -> Signal:
	if is_active_for_interaction:
		_stop_display()

	_initialize_display(new_text)
	_start_display()
	return display_complete

func _initialize_display(new_text: String) -> void:
	_letter_index = 0
	_text_to_display = new_text
	_current_voice_pair = VoiceManager.get_random_voice_pair()
	text = ""
	fast_forward = false

func _start_display() -> void:
	_display_timer.start(DEFAULT_DISPLAY_TIME)
	is_active_for_interaction = true

func _stop_display() -> void:
	_display_timer.stop()
	is_active_for_interaction = false

func _calculate_line_count(input_text: String) -> int:
	return max(1, ceili(float(input_text.length()) / estimated_line_char_length))

func _on_display_timer_timeout() -> void:
	if _should_complete_fast():
		_complete_display_immediately()
		return

	if _is_display_finished():
		_complete_display_normally()
		return

	_display_next_letter()


func _should_complete_fast() -> bool:
	return fast_forward

func _is_display_finished() -> bool:
	return _letter_index >= _text_to_display.length()

func _complete_display_immediately() -> void:
	_stop_display()
	text = _text_to_display
	fast_forward = false
	display_complete.emit()

func _complete_display_normally() -> void:
	is_active_for_interaction = false
	display_complete.emit()

func _display_next_letter() -> void:
	var letter: String = _text_to_display[_letter_index]

	if _should_play_voice_for_letter(letter):
		_play_voice_for_letter(letter)

	_letter_index += 1
	text += letter
	_display_timer.start(DEFAULT_DISPLAY_TIME)

func _should_play_voice_for_letter(letter: String) -> bool:
	return letter != " "

func _play_voice_for_letter(letter: String) -> void:
	var sound_stream: AudioStream = _get_sound_for_letter(letter)
	_voice.stream = sound_stream
	VoiceManager.set_voice_pitch(randf_range(PITCH_VARIATION_MIN, PITCH_VARIATION_MAX))
	_voice.play()

func _get_sound_for_letter(letter: String) -> AudioStream:
	if VOWELS.contains(letter):
		return _current_voice_pair[0]
	return _current_voice_pair[1]