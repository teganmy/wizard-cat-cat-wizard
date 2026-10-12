extends Area2D

enum STATE {ENTERED, IDLE}
var state: STATE = STATE.IDLE

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_change_state(STATE.ENTERED)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_change_state(STATE.IDLE)

func _change_state(new_state: STATE) -> void:
	state = new_state
