class_name Loot
extends RigidBody2D

signal picked_up(value: int)

@export var type: LootType
var value: int = 1
@onready var sprite := $Sprite2D
enum STATE {IDLE, GRABBED}
var state: STATE = STATE.IDLE
var follow: Node2D

func grab(new_follow: Node2D) -> void:
	_change_state(STATE.GRABBED)
	follow = new_follow

func is_grabbed() -> bool:
	return state == STATE.GRABBED

func _ready() -> void:
	value = type.value
	sprite.texture = type.sprite
	sprite.modulate = type.tint

func _physics_process(_delta: float) -> void:
	match state:
		STATE.GRABBED:
			if follow:
				apply_central_force(global_position.direction_to(follow.global_position) * 1000)
				if follow.global_position.distance_to(global_position) < 20:
					picked_up.emit(value)
					queue_free()

func _change_state(new_state: STATE) -> void:
	state = new_state
