class_name Lock
extends Node

enum STATE {LOCKED, UNLOCKED}
@export var state: STATE = STATE.LOCKED
signal locked
signal unlocked

func lock() -> void:
	match state:
		STATE.UNLOCKED:
			print("Locked")
			_change_state(STATE.LOCKED)
			locked.emit()
		STATE.LOCKED:
			pass

func unlock() -> void:
	match state:
		STATE.UNLOCKED:
			pass
		STATE.LOCKED:
			print("Unlocked")
			_change_state(STATE.UNLOCKED)
			unlocked.emit()

func is_locked() -> bool:
	return state == STATE.LOCKED

func _change_state(new_state: STATE) -> void:
	state = new_state
