class_name EnemySpawner
extends Marker2D

@export var radius: float = 0.0
## The enemy to spawn each wave, one per wave
@export var enemy_scene: PackedScene
@export var waves: Array[EnemyType] = []
@export var particle_color: Color = Color(0.805, 0.0, 0.131, 1.0)
var part_material = preload("res://components/spawner_particle_material.tres")
var current_wave: int = 0

func spawn() -> Node2D:
	var enemy
	if current_wave < waves.size() and waves[current_wave]:
		enemy = enemy_scene.instantiate()
		enemy.type = waves[current_wave]
		enemy.spawn_particle_color = particle_color
	current_wave += 1
	return enemy
