extends Node2D

@export var shooter: AreaShooter
var collision_mask_override: int
var direction = Vector2(1,1)

func _ready() -> void:
	for bullet in shooter.fire(position + direction):
		bullet.global_position = global_position
		bullet.hitbox.collision_mask = collision_mask_override
		add_sibling(bullet)
