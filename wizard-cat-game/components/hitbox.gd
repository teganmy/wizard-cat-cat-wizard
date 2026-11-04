class_name Hitbox
extends Area2D

@export var damage: int = 1
signal landed

func _ready() -> void:
	area_entered.connect(_damage)
	for area in get_overlapping_areas():
		_damage(area)

func _damage(area:Area2D) -> void:
	if area is Hurtbox:
		area.take_damage(damage)
		landed.emit()
