extends Node

var current_health: int:
	set(new):
		new = min(new, max_health)
		new = max(new, 0)
		current_health_changed.emit(new)
		current_health = new
var max_health: int:
	set(new):
		new = max(new, 0)
		max_health_changed.emit(new)
		max_health = new
var currency: int = 0:
	set(new):
		new = max(new, 0)
		currency_changed.emit(new)
		currency = new
var player_is_new: bool = true

signal current_health_changed(new: int)
signal max_health_changed(new: int)
signal currency_changed(new: int)

func _ready() -> void:
	add_to_group("Persistent")

func reset() -> void:
	current_health = 0
	max_health = 0
	currency = 0
	player_is_new = true

func save() -> Dictionary:
	return {
		"path": get_path(),
		"parent": get_parent(),
		"scene_path": scene_file_path,
		"current_health": current_health,
		"max_health": max_health,
		"currency": currency,
		"player_is_new": player_is_new,
	}
