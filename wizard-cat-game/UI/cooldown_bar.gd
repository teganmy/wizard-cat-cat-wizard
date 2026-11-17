extends ProgressBar

var timer: Timer
@export var player_state_signal_name: String

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(set.bind("value", max_value))
	add_child(timer)
	PlayerState.get(player_state_signal_name).connect(_on_cooldown_signal)
	value = max_value

func enable() -> void:
	show()

func disable() -> void:
	hide()

func _on_cooldown_signal(cooldown: float) -> void:
	timer.start(cooldown)
	max_value = cooldown
	value = 0

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		value = max_value - timer.time_left
