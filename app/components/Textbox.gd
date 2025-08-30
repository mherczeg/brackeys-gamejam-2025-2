class_name Textbox
extends Label

signal display_complete

const ESTIMATED_LINE_HEIGH: int = 19
const VOWELS: String = "aeiouAEIOU"

@export var consonant_sound: AudioStream
@export var vowel_sound: AudioStream
@export var estimated_line_char_length: int = 40
var letter_index: int = 0
var display_time: float = 0.02
var text_to_display: String = ""
var is_active_for_interaction: bool = false
var fast_forward: bool = false
var text_to_display_length: int = 0
var _current_consonant_sound: AudioStream
var _current_vowel_sound: AudioStream

@onready var display_timer: Timer = $DisplayTimer
@onready var voice: AudioStreamPlayer2D = $Voice

func _ready() -> void:
	display_timer.timeout.connect(_display_letter)

func clear_text() -> void:
	display_timer.stop()
	text = ""

func prepare_size_for_text(new_text: String) -> void:
	var lines: int = ceil(float(new_text.length()) / estimated_line_char_length)
	custom_minimum_size.y = max(0, lines) * ESTIMATED_LINE_HEIGH
	show()

func display_text(new_text: String) -> Signal:
	letter_index = 0
	text_to_display = new_text
	text_to_display_length = new_text.length()

	var voice_pair: Array[AudioStream] = VoiceManager.get_random_voice_pair()
	_current_vowel_sound = voice_pair[0]
	_current_consonant_sound = voice_pair[1]

	# start with timer instead of calling the function to sequence boxes
	display_timer.start(display_time)

	return display_complete

func _display_letter() -> void:
	if fast_forward:
		display_timer.stop()
		text = text_to_display
		fast_forward = false
		display_complete.emit()
		return

	if letter_index >= text_to_display_length:
		is_active_for_interaction = false
		display_complete.emit()
		return

	var letter: String = text_to_display[letter_index]

	if letter != " ":
		if VOWELS.contains(letter):
			voice.stream = _current_vowel_sound
		else:
			voice.stream = _current_consonant_sound

		VoiceManager.set_voice_pitch(randf_range(0.8, 1.2))
		voice.play()

	text += letter
	letter_index += 1
	display_timer.start(display_time)
