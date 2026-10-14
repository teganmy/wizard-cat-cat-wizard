extends Node2D

@export var player_scene: PackedScene
#@export var enemy_scene: PackedScene
@onready var spawn_point := $SpawnPoint
#@onready var enemy_spawns: Node2D = $EnemySpawns
#@export var enemy_respawn_delay: float = 2.0
var player: CharacterBody2D
#var enemy: Enemy

func _ready() -> void:
	var new_player = player_scene.instantiate()
	new_player.position = spawn_point.position
	new_player.add_to_group("player")
	add_child(new_player)
	new_player.health.died.connect(respawn_player)
	player = new_player
	$Room1.activate()
#	spawn_enemy()

func respawn_player() -> void:
	#player.position = spawn_point.position
	#player.health.heal_to_full()
	PlayerState.set_currency(0)
	get_tree().reload_current_scene.call_deferred()
	
#func spawn_enemy() -> void:
#	var spawn: Node2D = enemy_spawns.get_children().pick_random()
#	var new_enemy: Enemy = enemy_scene.instantiate()
#	new_enemy.died.connect(_on_enemy_died)
#	add_child(new_enemy)
#	new_enemy.global_position = spawn.global_position
#	enemy = new_enemy

#func _on_enemy_died() -> void:
#	await get_tree().create_timer(enemy_respawn_delay).timeout
#	spawn_enemy()
