class_name Laser
extends Node2D

const WARNING_TIME := 0.6

@export var damage: int = 1
@export var on_time: float = 0.7
@export var off_time: float = 1.6

@export var hitbox: Hitbox
@export var beam: ColorRect

var _cycle: Tween

func _ready() -> void:
	hitbox.damage = damage
	_set_state(0.0, false)
	start()

func start() -> void:
	#stop()
	_cycle = create_tween().set_loops()
	_cycle.tween_interval(off_time)
	_cycle.tween_callback(_set_state.bind(0.5, false)) # faint warning, harmless
	_cycle.tween_interval(WARNING_TIME)
	_cycle.tween_callback(_set_state.bind(1.0, true)) # firing
	_cycle.tween_interval(on_time)
	_cycle.tween_callback(_set_state.bind(0.0, false)) # off

func stop() -> void:
	if _cycle:
		_cycle.kill()
	_set_state(0.0, false)
	
func _physics_process(delta): 
	rotation += deg_to_rad(40.0) * delta

func _set_state(progress: float, harmful: bool) -> void:
	beam.material.set_shader_parameter("progress", progress)
	hitbox.set_deferred("monitoring", harmful)
