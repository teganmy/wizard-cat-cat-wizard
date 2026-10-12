extends Node

var current_health: int
var max_health: int
var currency: int = 0

signal current_health_changed(new: int)
signal max_health_changed(new: int)
signal currency_changed(new: int)

func set_max_health(new: int) -> void:
	max_health = new
	max_health_changed.emit(new)

func set_currency(new: int) -> void:
	currency = new
	currency_changed.emit(new)

func set_current_health(new: int) -> void:
	new =  min(new, max_health)
	current_health = new
	current_health_changed.emit(new)

func add_max_health(add: int) -> void:
	set_max_health(max_health + add)

func sub_max_health(sub: int) -> void:
	set_max_health(max_health - sub)

func add_currency(add: int) -> void:
	set_currency(currency + add)

func sub_currency(sub: int) -> void:
	set_currency(currency - sub)

func add_current_health(add: int) -> void:
	set_current_health(current_health + add)

func sub_current_health(sub: int) -> void:
	set_current_health(current_health - sub)
