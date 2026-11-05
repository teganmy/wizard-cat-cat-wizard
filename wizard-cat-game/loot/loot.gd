class_name Loot
extends RigidBody2D

signal picked_up(value: int)

@export var type: LootType
var value: int = 1
@onready var sprite := $Sprite2D
enum STATE {IDLE, GRABBED}
var state: STATE = STATE.IDLE
var follow: Node2D
@export var heal_amount: int = 0
@export var bullet_speed_multiplier: float = 1.0
@export var bullet_speed_duration: float = 0.0
@export var pull_start_speed: float = 120.0
@export var pull_max_speed: float = 450.0
@export var pull_accel: float = 900.0
var _pull_speed: float = 0.0

func grab(new_follow: Node2D) -> void:
	_change_state(STATE.GRABBED)
	follow = new_follow
	_pull_speed = pull_start_speed

func is_grabbed() -> bool:
	return state == STATE.GRABBED

func _ready() -> void:
	value = type.value
	sprite.texture = type.sprite
	sprite.modulate = type.tint

func _physics_process(delta: float) -> void:
	match state:
		STATE.GRABBED:
			if follow:
				_pull_speed = minf(_pull_speed + pull_accel * delta, pull_max_speed)
				linear_velocity = global_position.direction_to(follow.global_position) * _pull_speed
				if follow.global_position.distance_to(global_position) < 20:
					picked_up.emit(value)
					queue_free()

func _change_state(new_state: STATE) -> void:
	state = new_state
