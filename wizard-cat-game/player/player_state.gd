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

signal current_health_changed(new: int)
signal max_health_changed(new: int)
signal currency_changed(new: int)
