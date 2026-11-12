extends Control

@export var secondary_list: GridContainer
@export var pause_rect: ColorRect

func _ready() -> void:
	hide()

func open() -> void:
	show()
	if pause_rect:
		pause_rect.show()
	secondary_list.reload()

func close() -> void:
	if pause_rect:
		pause_rect.hide()
	hide()
