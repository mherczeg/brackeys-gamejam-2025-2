class_name Utils
extends RefCounted

static func clear_children(parent: Node) -> void:
	for child: Node in parent.get_children():
		child.free()