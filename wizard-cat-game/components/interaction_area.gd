class_name InteractionArea
extends Area2D

enum STATE {ENTERED, IDLE}
var state: STATE = STATE.IDLE
signal interact

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node2D) -> void:
	_change_state(STATE.ENTERED)

func _on_body_exited(_body: Node2D) -> void:
	_change_state(STATE.IDLE)

func _change_state(new_state: STATE) -> void:
	state = new_state

func _process(_delta: float) -> void:
	if state == STATE.ENTERED:
		if Input.is_action_just_pressed("interact"):
			interact.emit()
