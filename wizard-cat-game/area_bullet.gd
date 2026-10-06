extends Area2D

@export var dir: Vector2 = Vector2.ZERO
@export var speed: float = 500.0

func _physics_process(delta: float) -> void:
	translate(dir*speed*delta)


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
