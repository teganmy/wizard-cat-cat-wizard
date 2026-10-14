class_name Lock
extends Node

enum STATE {LOCKED, UNLOCKED}
var state: STATE = STATE.LOCKED
signal locked
signal unlocked

func lock() -> void:
	match state:
		STATE.UNLOCKED:
			_change_state(STATE.LOCKED)
			locked.emit()
		STATE.LOCKED:
			pass

func unlock() -> void:
	match state:
		STATE.UNLOCKED:
			pass
		STATE.LOCKED:
			_change_state(STATE.UNLOCKED)
			unlocked.emit()

func is_locked() -> bool:
	return state == STATE.LOCKED

func _change_state(new_state: STATE) -> void:
	state = new_state
