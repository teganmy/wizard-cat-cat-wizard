class_name Shooter
extends Node2D

@export var bullet: PackedScene
@export var firing_impulse: float = 500.0

func fire(target: Vector2) -> RigidBody2D:
	var new_bullet: RigidBody2D = bullet.instantiate()
	new_bullet.position = self.global_position
	new_bullet.apply_central_impulse(new_bullet.global_position.direction_to(target) * firing_impulse)
	return new_bullet
