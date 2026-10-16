class_name AreaShooter
extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_type: BulletType

func fire(target: Vector2) -> Area2D:
	if bullet_type.custom_bullet_scene:
		bullet_scene = bullet_type.custom_bullet_scene
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = global_position
	new_bullet.dir = new_bullet.global_position.direction_to(target)
	new_bullet.type = bullet_type
	return new_bullet
