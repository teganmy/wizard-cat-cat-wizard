extends Node2D

var collision_mask_override: int
@export var hitbox: Hitbox
@export var explosion_effect: ColorRect
@export var timer: Timer
@export var lifetime: float = 1.0

func _ready() -> void:
	if collision_mask_override:
		hitbox.collision_mask = collision_mask_override
	explosion_effect.show()
	timer.start(lifetime)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	var set_param: Callable = func(value: float): explosion_effect.material.set_shader_parameter("frame_scope", value)
	tween.tween_method(set_param, 10.0, 2.0, lifetime/5)

func _on_life_timer_timeout() -> void:
	queue_free()
