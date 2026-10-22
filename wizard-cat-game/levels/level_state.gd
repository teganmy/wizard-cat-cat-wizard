extends Node

signal exited
signal entered
signal exit_tried

enum STATE {ACTIVE, INACTIVE}
var pausable: bool = false
var state: STATE = STATE.INACTIVE

func exit() -> void:
	if state == STATE.ACTIVE:
		exited.emit()
		_change_state(STATE.INACTIVE)

func enter() -> void:
	if state == STATE.INACTIVE:
		entered.emit()
		_change_state(STATE.ACTIVE)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.ACTIVE:
			pausable = true
		STATE.INACTIVE:
			pausable = false

func try_exit() -> void:
	exit_tried.emit()
