class_name EnemySpawner
extends Marker2D

## The enemy to spawn each wave, one per wave
@export var waves: Array[PackedScene] = []
var current_wave: int = 0

func spawn() -> Node2D:
	var enemy
	if current_wave < waves.size():
		enemy = waves[current_wave].instantiate()
	current_wave += 1
	return enemy
