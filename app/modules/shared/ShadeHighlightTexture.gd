class_name ShadeHighlightTexture
extends Node

@export var material: ShaderMaterial

@export_group("Shader Parameters")
@export var shader_width_param: StringName = &"width"
@export var shader_color_param: StringName = &"outline_color"

@export_group("Shader States")
@export var default_width: float = 0.0
@export var hover_width: float = 2.0
@export var default_color: Color = Color.WHITE

var _highlightable: Control

func _ready() -> void:
	_highlightable = get_parent() as Control

	if not _highlightable:
		printerr("ShaderButtonController must be a child of a Control.")
		return

	_config_shader()


func _config_shader() -> void:
	_highlightable.material = material.duplicate()

	_highlightable.mouse_entered.connect(_on_mouse_entered)
	_highlightable.mouse_exited.connect(_on_mouse_exited)

	_set_shader_param(shader_width_param, default_width)
	_set_shader_param(shader_color_param, default_color)

func _on_mouse_entered() -> void:
	_set_shader_param(shader_width_param, hover_width)

func _on_mouse_exited() -> void:
	_set_shader_param(shader_width_param, default_width)

func _set_shader_param(param: StringName, value: Variant) -> void:
	var mat: ShaderMaterial = _highlightable.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter(param, value)
