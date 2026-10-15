class_name EnemySpawner
extends Marker2D

## The enemy to spawn each wave, one per wave
@export var waves: Array[PackedScene] = []
@export var particle_color: Color = Color(0.805, 0.0, 0.131, 1.0)
var particles: GPUParticles2D
var part_material = preload("res://components/spawner_particle_material.tres")
var current_wave: int = 0

func spawn() -> Node2D:
	var enemy
	if current_wave < waves.size() and waves[current_wave]:
		enemy = waves[current_wave].instantiate()
	if enemy:
		particles.emitting = true
	current_wave += 1
	return enemy

func _ready() -> void:
	particles = GPUParticles2D.new()
	particles.emitting = false
	particles.process_material = part_material
	particles.modulate = particle_color
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = 30
	add_child(particles)
