@abstract class_name Room
extends Area2D

@export var visible_on_enter: bool = false

enum STATE {UNEXPLORED, REVEALED, ACTIVE, DEFEATED}
var state: STATE

signal defeated
signal activated
signal revealed

func _change_state(new_state: STATE) -> void:
	state = new_state

func activate() -> void:
	if state == STATE.REVEALED:
		activated.emit()
		_change_state(STATE.ACTIVE)

func reveal() -> void:
	if state == STATE.UNEXPLORED:
		revealed.emit()
		_change_state(STATE.REVEALED)

func defeat() -> void:
	if state == STATE.ACTIVE:
		defeated.emit()
		_change_state(STATE.DEFEATED)
