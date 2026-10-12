extends Node2D

@export var player_scene: PackedScene
@onready var spawn_point := $SpawnPoint
var player: CharacterBody2D

func _ready() -> void:
	var new_player = player_scene.instantiate()
	new_player.position = spawn_point.position
	add_child(new_player)
	new_player.health.died.connect(respawn_player)
	player = new_player

func respawn_player() -> void:
	player.position = spawn_point.position
	player.health.heal_to_full()
