extends Node
var fire_rate_multiplier: float = 1.0
var _boost_timer: Timer

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
signal fire_rate_boost_changed(multiplier: float)

func _ready() -> void:
	add_to_group("Persistent")
	_boost_timer = Timer.new()
	_boost_timer.one_shot = true
	_boost_timer.timeout.connect(clear_fire_rate_boost)
	add_child(_boost_timer)
	
func apply_fire_rate_boost(multiplier: float, duration: float) -> void:
	fire_rate_multiplier = multiplier
	_boost_timer.start(duration)
	fire_rate_boost_changed.emit(multiplier)
func clear_fire_rate_boost() -> void:
	fire_rate_multiplier = 1.0
	_boost_timer.stop()
	fire_rate_boost_changed.emit(1.0)
	
func reset() -> void:
	current_health = 0
	max_health = 0
	currency = 0
	clear_fire_rate_boost()
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
