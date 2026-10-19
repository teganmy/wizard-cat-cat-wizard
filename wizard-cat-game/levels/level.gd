extends Node2D

@export var player_scene: PackedScene
@onready var spawn_point := $SpawnPoint
var player: CharacterBody2D

func _ready() -> void:
	var new_player = player_scene.instantiate()
	new_player.position = spawn_point.position
	new_player.add_to_group("player")
	add_child(new_player)
	new_player.health.died.connect(respawn_player)
	player = new_player
	LevelState.enter()

func respawn_player() -> void:
	PlayerState.set_currency(0)
	get_tree().reload_current_scene.call_deferred()
