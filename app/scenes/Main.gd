class_name Main
extends Node2D

const MENU_SCENE: PackedScene = preload("res://modules/menu/Menu.tscn")
const GAME_SCENE: PackedScene = preload("res://modules/game/Game.tscn")

@onready var menu: Menu
@onready var game: Game

func _ready() -> void:
	_init_menu()
	_connect_signals()

func _init_menu() -> void:
	menu = MENU_SCENE.instantiate()
	add_child(menu)
	menu.new_game_button.pressed.connect(_on_menu_new_game_pressed, ConnectFlags.CONNECT_ONE_SHOT)
	menu.exit.pressed.connect(_on_menu_exit_pressed, ConnectFlags.CONNECT_ONE_SHOT)

func _connect_signals() -> void:
	EventBus.ui.exit.connect(_on_ui_exit)

func _on_menu_new_game_pressed() -> void:
	game = GAME_SCENE.instantiate()
	add_child(game)
	if menu:
		menu.queue_free()

func _on_menu_exit_pressed() -> void:
	get_tree().quit()

func _on_ui_exit() -> void:
	_init_menu()
	if game:
		game.queue_free()
