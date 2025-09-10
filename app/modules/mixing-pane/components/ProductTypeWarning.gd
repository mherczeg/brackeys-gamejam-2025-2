class_name ProductTypeWarning
extends Label

func _ready() -> void:
    EventBus.mixer.product_type_warning.connect(_on_state_change)


func _on_state_change(is_visible_state: bool) -> void:
    if is_visible_state:
        show()
    else:
        hide()
