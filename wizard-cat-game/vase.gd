extends StaticBody2D

func _on_health_died() -> void:
	$Lootable.generate_loot()
	queue_free()
