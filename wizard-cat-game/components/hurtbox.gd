class_name Hurtbox
extends Area2D

@export var health: Health

func take_damage(amount: int) -> void:
	if health != null:
		health.hurt(amount)
