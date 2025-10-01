class_name GameWindowButtons
extends HBoxContainer

@onready var open_npc_pane_button: TextureButton = %OpenNPCPane
@onready var exit_button: TextureButton = %Exit

func _ready() -> void:
    open_npc_pane_button.pressed.connect(_on_npc_pane_button_pressed)
    exit_button.pressed.connect(_on_exit_button_pressed)

func _on_npc_pane_button_pressed() -> void:
    EventBus.ui.toggle_npc_pane.emit()

func _on_exit_button_pressed() -> void:
    EventBus.ui.exit.emit()
