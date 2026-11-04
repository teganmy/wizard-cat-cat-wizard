extends Node2D

var collision_mask_override: int
@export var hitbox: Hitbox


func _ready() -> void:
	if collision_mask_override:
		hitbox.collision_mask = collision_mask_override

func _on_life_timer_timeout() -> void:
	queue_free()
