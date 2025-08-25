extends HBoxContainer

const BASES_PATH: String = "res://resources/bases"
const BASE_SELECTOR_BUTTON_SCENE: PackedScene = preload("res://components/BaseSelectorButton.tscn")


var base_db: Array[Base] = []

func _init() -> void:
    _load_all_bases()

func _ready() -> void:
    for base: Base in base_db:
        var button_instance: BaseSelectorButton = BASE_SELECTOR_BUTTON_SCENE.instantiate()
        button_instance.base = base
        add_child(button_instance)


func _load_all_bases() -> void:
    var dir: DirAccess = DirAccess.open(BASES_PATH)
    if dir:
        for file_name: String in dir.get_files():
            if file_name.ends_with(".tres"):
                var resource: Resource = load(BASES_PATH.path_join(file_name))
                if resource is Base:
                    base_db.append(resource)