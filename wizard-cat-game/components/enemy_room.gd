class_name EnemyRoom
extends Room

@export var lockables: Array[StaticBody2D] = []
var total_waves: int = 1
var spawners: Array[EnemySpawner] = []
signal wave

var living_enemies: int = 0
var current_wave: int = 0

func _ready() -> void:
	hide()
	body_entered.connect(activate.unbind(1))
	for child in get_children():
		if child is EnemySpawner:
			spawners.append(child)
			total_waves = max(total_waves, child.waves.size())
	for lockable in lockables:
		if lockable.lock.has_method("lock"):
			revealed.connect(lockable.lock.unlock)
			defeated.connect(lockable.lock.unlock)
			activated.connect(lockable.lock.lock)
	if visible_on_enter:
		get_tree().current_scene.entered.connect(reveal)

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.REVEALED:
			_on_revealed()
		STATE.ACTIVE:
			_on_activated()
		STATE.DEFEATED:
			pass

func _on_activated() -> void:
	get_tree().current_scene.current_room = self
	_wave.call_deferred()

func _on_revealed() -> void:
	show()

func _wave() -> void:
	if current_wave < total_waves:
		await get_tree().create_timer(randf_range(2.0,3.0)).timeout
		for spawner in spawners:
			var enemy = spawner.spawn()
			if enemy:
				var r = spawner.radius * sqrt(randf())
				var theta = 2 * PI * randf()
				var enemy_position = Vector2(r * cos(theta), r * sin(theta))
				enemy.position = spawner.position + enemy_position
				add_child(enemy)
				living_enemies += 1
				enemy.died.connect(_on_enemy_died)
		current_wave += 1
		wave.emit(current_wave)
	else:
		await get_tree().create_timer(0.25).timeout
		defeat()

func _on_enemy_died() -> void:
	living_enemies -= 1
	if living_enemies <= 0:
		living_enemies = 0
		_wave.call_deferred()
