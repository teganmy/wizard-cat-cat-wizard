class_name EnemySpawner
extends Node2D

## The enemy to spawn each wave, one per wave
@export var waves: Array[PackedScene] = []
var current_wave: int = 0

func spawn() -> Node2D:
	current_wave += 1
	if current_wave < waves.size():
		var enemy = waves[current_wave].instantiate()
		return enemy
	else:
		return null
