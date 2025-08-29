class_name ShadeButtonTexture
extends Node

@export var material: ShaderMaterial

@export_group("Shader Parameters")
@export var shader_width_param: StringName = &"width"
@export var shader_color_param: StringName = &"outline_color"
@export var shader_grayscale_param: StringName = &"grayscale"

@export_group("Shader States")
@export var default_width: float = 1.0
@export var hover_width: float = 2.5
@export var pressed_width: float = 2.0
@export var default_color: Color = Color.WHITE
@export var pressed_color: Color = Color.BLACK

var _button: TextureButton
var _last_disabled_state: bool = false

func _ready() -> void:
	_button = get_parent() as TextureButton

	if not _button:
		printerr("ShaderButtonController must be a child of a TextureButton.")
		return

	_config_shader()
	_config_disabled_state_handler()


func _config_shader() -> void:
	_button.material = material.duplicate()

	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)
	_button.button_down.connect(_on_button_down)
	_button.button_up.connect(_on_button_up)

	_set_shader_param(shader_width_param, default_width)
	_set_shader_param(shader_color_param, default_color)

func _config_disabled_state_handler() -> void:
	_last_disabled_state = _button.disabled
	if _button.has_signal("disabled_changed"):
		_button.disabled_changed.connect(_update_shader_disabled_state)

func _update_shader_disabled_state() -> void:
	if _button.disabled:
		_set_shader_param(shader_grayscale_param, 1.0)
		_set_shader_param(shader_width_param, default_width)
		_set_shader_param(shader_color_param, default_color)
	else:
		_set_shader_param(shader_grayscale_param, 0.0)

func _on_mouse_entered() -> void:
	if _button.disabled: return
	if not _button.button_pressed:
		_set_shader_param(shader_width_param, hover_width)

func _on_mouse_exited() -> void:
	if _button.disabled: return
	if not _button.button_pressed:
		_set_shader_param(shader_width_param, default_width)
		_set_shader_param(shader_color_param, default_color)

func _on_button_down() -> void:
	if _button.disabled: return
	_set_shader_param(shader_width_param, pressed_width)
	_set_shader_param(shader_color_param, pressed_color)

func _on_button_up() -> void:
	if _button.disabled: return
	_set_shader_param(shader_color_param, default_color)
	if _button.is_hovered():
		_set_shader_param(shader_width_param, hover_width)
	else:
		_set_shader_param(shader_width_param, default_width)

func _set_shader_param(param: StringName, value: Variant) -> void:
	var mat: ShaderMaterial = _button.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter(param, value)
