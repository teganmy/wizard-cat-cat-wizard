class_name Hitbox
extends Area2D

@export var damage: int = 1
@export var hit_time: float = 1.0
signal landed
var hit_timer: Timer
var entered: int = 0

func _ready() -> void:
	hit_timer = Timer.new()
	hit_timer.wait_time = hit_time
	hit_timer.timeout.connect(_tick)
	add_child(hit_timer)
	area_entered.connect(_damage)
	area_exited.connect(_remove_entered.unbind(1))
	for area in get_overlapping_areas():
		_damage(area)

func _damage(area:Area2D) -> void:
	if area is Hurtbox:
		if entered == 0:
			hit_timer.start()
		entered += 1
		area.take_damage(damage)
		landed.emit()

func _tick() -> void:
	if monitoring:
		for area in get_overlapping_areas():
			if area is Hurtbox:
				area.take_damage(damage)
				landed.emit()

func _remove_entered() -> void:
	entered -= 1
	if entered == 0:
		hit_timer.stop()
