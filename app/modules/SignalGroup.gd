class_name SignalGroup
extends RefCounted

signal all_complete

var _counter: int = 0

func all(signals: Array[Signal]) -> void:
	_counter = signals.size()

	if _counter == 0:
		return

	for sig: Signal in signals:
		sig.connect(_on_signal_complete, CONNECT_ONE_SHOT)

	await all_complete

func _on_signal_complete() -> void:
	_counter -= 1
	if _counter == 0:
		all_complete.emit()
