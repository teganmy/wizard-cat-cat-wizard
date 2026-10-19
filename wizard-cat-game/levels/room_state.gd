extends Node

var current_wave: int = 0
enum STATE {INACTIVE, ACTIVE}
var state: STATE = STATE.INACTIVE
var max_waves: int = 1
signal defeated
signal activated
signal wave(new_wave: int)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.INACTIVE:
			defeated.emit()
		STATE.ACTIVE:
			activated.emit()

func defeat() -> void:
	current_wave = 0
	_change_state(STATE.INACTIVE)

func activate(num_waves: int) -> void:
	max_waves = num_waves
	_change_state(STATE.ACTIVE)

func change_wave(new_wave: int) -> void:
	current_wave = new_wave
	if state == STATE.ACTIVE:
		wave.emit(new_wave)
