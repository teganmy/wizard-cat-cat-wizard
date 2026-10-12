extends StaticBody2D

var opened: bool = false
@onready var sprite := $Sprite2D

func _on_interaction_area_interact() -> void:
	if not opened:
		$Lootable.generate_loot()
		opened = true
		sprite.modulate = Color.DARK_GRAY


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if not opened:
		create_tween().tween_property(sprite, "modulate", Color.YELLOW, 0.1)

func _on_interaction_area_body_exited(_body: Node2D) -> void:
	if not opened:
		create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.1)
