class_name Laser
extends Node2D

const WARNING_TIME := 0.6

@export var damage: int = 1
@export var on_time: float = 0.7
@export var off_time: float = 1.6

@onready var hitbox: Hitbox = $Hitbox
@onready var beam: ColorRect = $Beam

var _cycle: Tween

func _ready() -> void:
	hitbox.damage = damage
	_set_state(0.0, false)
	start()

func start() -> void:
	stop()
	_cycle = create_tween().set_loops()
	_cycle.tween_interval(off_time)
	_cycle.tween_callback(_set_state.bind(0.3, false)) # faint warning, harmless
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

func _set_state(alpha: float, harmful: bool) -> void:
	beam.modulate.a = alpha
	hitbox.set_deferred("monitoring", harmful)
