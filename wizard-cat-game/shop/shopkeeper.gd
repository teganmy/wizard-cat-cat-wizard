extends StaticBody2D

@export var shop: Shop

func _on_interaction_area_interact() -> void:
	shop.open()
