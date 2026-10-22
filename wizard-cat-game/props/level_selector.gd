extends StaticBody2D

@export var level_select: Control
@export var portal: StaticBody2D


func _ready() -> void:
	level_select.level_selected.connect(func(level: int): portal.level = level; portal.lock.unlock())

func _on_interaction_area_interact() -> void:
	level_select.open()
