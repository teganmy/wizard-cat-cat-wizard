class_name AreaShooter
extends Node2D
@export var bullet_scene: PackedScene
@export var bullet_type: BulletType
@export var firing_pattern: FiringPattern
@export var use_player_boost: bool
var _default_bullet_scene: PackedScene
var count: int = 0
var spread: float = 0 
enum STATE {READY, COOLDOWN}
var state: STATE = STATE.READY
var cooldown_timer: Timer
signal fired
signal ready_to_fire

func _ready() -> void:
	_default_bullet_scene = bullet_scene
	if bullet_type and firing_pattern:
		configure(bullet_type, firing_pattern)
		
func configure(new_type: BulletType, new_pattern: FiringPattern) -> void:
	bullet_type = new_type
	firing_pattern = new_pattern
	if bullet_type.custom_bullet_scene:
		bullet_scene = bullet_type.custom_bullet_scene
	else:
		bullet_scene = _default_bullet_scene
	setup_pattern()
	
func fire(target: Vector2) -> Array[Area2D]:
	var bullets: Array[Area2D] = []
	if firing_pattern == null or bullet_scene == null:
		return bullets
	match state:
		STATE.READY:
			for i in range(count):
				var angle: float = 0.0
				if count > 1:
					angle = i * (spread / (count - 1)) - spread / 2
				var new_bullet = bullet_scene.instantiate()
				new_bullet.global_position = global_position
				new_bullet.dir = new_bullet.global_position.direction_to(target).rotated(angle)
				new_bullet.type = bullet_type
				bullets.append(new_bullet)
			_change_state(STATE.COOLDOWN)
			var rate: float = PlayerState.fire_rate_multiplier if use_player_boost else 1.0
			cooldown_timer.start(firing_pattern.cooldown / maxf(rate, 0.01))
			fired.emit()
	return bullets

func _change_state(new_state: STATE) -> void:
	state = new_state
	match state:
		STATE.READY:
			ready_to_fire.emit()

func setup_pattern():
	count = firing_pattern.count
	spread = firing_pattern.spread
	if not cooldown_timer:
		cooldown_timer = Timer.new()
		cooldown_timer.timeout.connect(_change_state.bind(STATE.READY))
		add_child(cooldown_timer)
	cooldown_timer.stop()
	cooldown_timer.wait_time = firing_pattern.cooldown
	ready_to_fire.emit()
	_change_state(STATE.READY)
