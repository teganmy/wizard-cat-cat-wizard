class_name AreaShooter
extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_type: BulletType
@export var firing_pattern: FiringPattern

func fire(target: Vector2) -> Array[Area2D]:
	if bullet_type.custom_bullet_scene:
		bullet_scene = bullet_type.custom_bullet_scene
	var bullets: Array[Area2D] = []
	for i in range(firing_pattern.count):
		var angle: float = 0.0
		if firing_pattern.count > 1:
			angle = i * (firing_pattern.spread / (firing_pattern.count - 1)) - firing_pattern.spread / 2
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_position = global_position
		new_bullet.dir = new_bullet.global_position.direction_to(target).rotated(angle)
		new_bullet.type = bullet_type
		bullets.append(new_bullet)
	return bullets
