class_name NPCPane
extends Control


const NPC_INFO_BOX: PackedScene = \
	preload("res://modules/npc-db/components/NPCInfoBox.tscn")

@onready var items: VBoxContainer = %Items
@onready var close_button: Button = %CloseButton

func _ready() -> void:
	hide()
	close_button.pressed.connect(hide)

func open() -> void:
	reset_items()

	for npc: NPC in Player.order_history.get_served_npcs():
		var npc_info_box: NPCInfoBox = NPC_INFO_BOX.instantiate()
		items.add_child(npc_info_box)
		npc_info_box.set_npc(npc, Player.order_history.get_npc_orders(npc))
		npc_info_box.order_history.show()

	show()

func reset_items() -> void:
	for child: Node in items.get_children():
		child.free()
