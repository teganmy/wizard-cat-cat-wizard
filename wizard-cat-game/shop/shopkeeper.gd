extends StaticBody2D

@export var shop: Control

func _on_interaction_area_interact() -> void:
	shop.open()
