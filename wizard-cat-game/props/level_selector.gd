extends StaticBody2D

@export var level_select: Control
@export var portal: StaticBody2D


func _ready() -> void:
	level_select.level_selected.connect(_on_level_selected)

func _on_interaction_area_interact() -> void:
	level_select.open()

func _on_level_selected(def: LevelDef) -> void:
	portal.level = def
	portal.lock.unlock()
