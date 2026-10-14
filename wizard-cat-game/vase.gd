extends StaticBody2D

func _on_health_died() -> void:
	$Lootable.generate_loot()
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox.queue_free()
	var part := $GPUParticles2D
	part.emitting = true
	await part.finished
	queue_free()
