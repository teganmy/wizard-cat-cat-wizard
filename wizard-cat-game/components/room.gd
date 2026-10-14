class_name Room
extends Node2D

@export var lockables: Array[StaticBody2D] = []
@export var spawners: Array[EnemySpawner] = []
@export var total_waves: int = 1
enum STATE {UNEXPLORED, ACTIVE, DEFEATED}
var state: STATE = STATE.UNEXPLORED
signal defeated
signal activated

var living_enemies: int = 0
var current_wave: int = 0

func _ready() -> void:
	hide()
	for lockable in lockables:
		if lockable.lock.has_method("lock"):
			defeated.connect(lockable.lock.unlock)
			activated.connect(lockable.lock.lock)

func activate() -> void:
	_change_state(STATE.ACTIVE)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.ACTIVE:
			_on_activated()
		STATE.DEFEATED:
			_on_defeated()

func _on_defeated() -> void:
	print("Defeated")
	defeated.emit()

func _on_activated() -> void:
	print("Activated")
	activated.emit()
	_wave()
	show()

func _wave() -> void:
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
	print("Enemy died, left: ", living_enemies)
	living_enemies -= 1
	if living_enemies <= 0:
		living_enemies = 0
		_wave()
