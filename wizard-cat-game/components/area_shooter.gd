class_name AreaShooter
extends Node2D

@export var bullet: PackedScene
@export var fire_speed: float = 500

func fire(target: Vector2) -> Area2D:
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = global_position
	new_bullet.dir = new_bullet.global_position.direction_to(target)
	new_bullet.speed = fire_speed
	return new_bullet
