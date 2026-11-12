extends StaticBody2D

@export var equip_menu: Control

func open() -> void:
	if equip_menu.has_method("open"):
		equip_menu.open()
