class_name Health
extends Node

@export var max_health: int = 1
var current
signal changed(current: int)
signal died
var is_dead:bool = false

func _ready() -> void:
	current = max_health

func _change_current(amount: int) -> void:
	current = clampi(current + amount, 0, max_health)
	changed.emit(current)
	if current <= 0 and not is_dead:
		is_dead = true
		died.emit()
	if current > 0 and is_dead:
		is_dead = false

func hurt(amount: int) -> void:
	_change_current(-amount)

func heal(amount:int) -> void:
	_change_current(amount)

func heal_to_full() -> void:
	_change_current(max_health)

func set_max(new_max: int) -> void:
	max_health = new_max
	current = max_health
	changed.emit(current)
