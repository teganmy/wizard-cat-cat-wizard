class_name Hurtbox
extends Area2D

@export var health: Health
signal hurt
var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

func take_damage(amount: int, delay: float = 0) -> void:
	if health != null and timer.is_stopped():
		health.hurt(amount)
		hurt.emit()
		if delay > 0:
			timer.start(delay)
