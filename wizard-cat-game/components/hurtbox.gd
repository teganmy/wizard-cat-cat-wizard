class_name Hurtbox
extends Area2D

@export var health: Health
signal hurt

func take_damage(amount: int) -> void:
	if health != null:
		health.hurt(amount)
		hurt.emit()
