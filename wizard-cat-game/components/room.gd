class_name Room
extends Node2D

## Area2Ds that are aligned to detect an entering player
@export var enter_detectors: Array[Area2D] = []
@export var doors: Array[StaticBody2D] = []
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
	for det in enter_detectors:
		det.body_entered.connect(_on_room_entered)
	for door in doors:
		if door.has_method("lock"):
			defeated.connect(door.unlock)
			activated.connect(door.lock)

func _on_room_entered(_body: Node2D) -> void:
	_change_state(STATE.ACTIVE)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.ACTIVE:
			_on_activated()
		STATE.DEFEATED:
			_on_defeated()

func _on_defeated() -> void:
	defeated.emit()

func _on_activated() -> void:
	activated.emit()
	show()

func _wave() -> void:
	if current_wave <= total_waves:
		for spawner in spawners:
			var enemy = spawner.spawn()
			if enemy:
				add_child(enemy)
				living_enemies += 1
				enemy.died.connect(_on_enemy_died)
	else:
		_change_state(STATE.DEFEATED)

func _on_enemy_died() -> void:
	living_enemies -= 1
	if living_enemies <= 0:
		living_enemies = 0
		_wave()
