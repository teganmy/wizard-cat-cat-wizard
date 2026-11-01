extends Node2D

@export var player_scene: PackedScene
@export var exit_portal: StaticBody2D
@onready var spawn_point := $SpawnPoint
var player: CharacterBody2D
signal exited
signal entered
signal wave(num: int)
signal room_changed
signal room_defeated
signal boss_spawned(name: String, health: Health)
signal boss_defeated

enum STATE {ACTIVE, INACTIVE}
var pausable: bool = false
var state: STATE = STATE.INACTIVE
var portal_enabled: bool = false

var current_room: Room:
	set(new):
		if current_room:
			if current_room is EnemyRoom and current_room.wave.is_connected(wave.emit):
				current_room.wave.disconnect(wave.emit)
			if current_room.defeated.is_connected(room_defeated.emit):
				current_room.defeated.disconnect(room_defeated.emit)
		if new is EnemyRoom:
			new.wave.connect(wave.emit)
		new.defeated.connect(room_defeated.emit)
		current_room = new
		room_changed.emit()

func _ready() -> void:
	var new_player = player_scene.instantiate()
	new_player.position = spawn_point.position
	new_player.add_to_group("player")
	add_child(new_player)
	new_player.health.died.connect(respawn_player)
	player = new_player
	if exit_portal and exit_portal.lock and exit_portal.lock.has_signal("unlocked"):
		exit_portal.lock.unlocked.connect(_on_exit_portal_unlocked)
	enter()

func respawn_player() -> void:
	PlayerState.currency = 0
	exit()
	get_tree().reload_current_scene.call_deferred()

func exit() -> void:
	if state == STATE.ACTIVE:
		Save.save_current()
		exited.emit()
		_change_state(STATE.INACTIVE)

func enter() -> void:
	if state == STATE.INACTIVE:
		entered.emit()
		_change_state(STATE.ACTIVE)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.ACTIVE:
			pausable = true
		STATE.INACTIVE:
			pausable = false

func spawn_boss(boss: CharacterBody2D) -> void:
	boss_spawned.emit(boss.boss_name, boss.health)
	boss.defeated.connect(_on_boss_defeated)

func _on_exit_portal_unlocked() -> void:
	if not portal_enabled:
		exit_portal.lock.lock()

func _on_boss_defeated() -> void:
	boss_defeated.emit()
	portal_enabled = true
	exit_portal.lock.unlock()
