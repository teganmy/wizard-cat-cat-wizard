extends Area2D

var dir: Vector2 = Vector2.ZERO
var speed: float = 100.0

func _physics_process(delta: float) -> void:
	translate(speed * dir * delta)

func _on_area_entered(_area: Area2D) -> void:
	dir = -dir
