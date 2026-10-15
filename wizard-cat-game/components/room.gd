class_name Room
extends Area2D

@export var lockables: Array[StaticBody2D] = []
@export var spawners: Array[EnemySpawner] = []
@export var total_waves: int = 1
enum STATE {UNEXPLORED, REVEALED, ACTIVE, DEFEATED}
var state: STATE = STATE.UNEXPLORED
signal defeated
signal activated
signal revealed

var living_enemies: int = 0
var current_wave: int = 0

func _ready() -> void:
	hide()
	body_entered.connect(activate.unbind(1))
	for lockable in lockables:
		if lockable.lock.has_method("lock"):
			revealed.connect(lockable.lock.unlock)
			defeated.connect(lockable.lock.unlock)
			activated.connect(lockable.lock.lock)

func activate() -> void:
	if state == STATE.REVEALED:
		_change_state(STATE.ACTIVE)

func reveal() -> void:
	if state == STATE.UNEXPLORED:
		_change_state(STATE.REVEALED)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.REVEALED:
			_on_revealed()
		STATE.ACTIVE:
			_on_activated()
		STATE.DEFEATED:
			_on_defeated()

func _on_defeated() -> void:
	defeated.emit()

func _on_activated() -> void:
	activated.emit()
	_wave.call_deferred()

func _on_revealed() -> void:
	show()
	revealed.emit()

func _wave() -> void:
	await get_tree().create_timer(randf_range(2.0,3.0)).timeout
	if current_wave < total_waves:
		for spawner in spawners:
			var enemy = spawner.spawn()
			if enemy:
				enemy.position = spawner.position
				add_child(enemy)
				living_enemies += 1
				enemy.died.connect(_on_enemy_died)
	else:
		_change_state(STATE.DEFEATED)
	current_wave += 1

func _on_enemy_died() -> void:
	living_enemies -= 1
	if living_enemies <= 0:
		living_enemies = 0
		_wave.call_deferred()
