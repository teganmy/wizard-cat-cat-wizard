extends Node

signal exited
signal entered

enum STATE {ACTIVE, INACTIVE}
var state: STATE = STATE.INACTIVE

func exit() -> void:
	if state == STATE.ACTIVE:
		exited.emit()

func enter() -> void:
	if state == STATE.INACTIVE:
		entered.emit()

func _change_state(new_state: STATE) -> void:
	state = new_state

func can_pause() -> bool:
	return state == STATE.ACTIVE
