class_name AreaShooter
extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_type: BulletType
@export var firing_pattern: FiringPattern
var count: int = 0
var spread: float = 0
enum STATE {READY, COOLDOWN}
var state: STATE = STATE.READY
var cooldown_timer: Timer
signal fired
signal ready_to_fire

func _ready() -> void:
	if bullet_type.custom_bullet_scene:
		bullet_scene = bullet_type.custom_bullet_scene
	count = firing_pattern.count
	spread = firing_pattern.spread
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = firing_pattern.cooldown
	cooldown_timer.timeout.connect(_change_state.bind(STATE.READY))
	add_child(cooldown_timer)
	ready_to_fire.connect(print.bind("READY"))
	ready_to_fire.emit()

func fire(target: Vector2) -> Array[Area2D]:
	var bullets: Array[Area2D] = []
	match state:
		STATE.READY:
			for i in range(firing_pattern.count):
				var angle: float = 0.0
				if count > 1:
					angle = i * (spread / (count - 1)) - spread / 2
				var new_bullet = bullet_scene.instantiate()
				new_bullet.global_position = global_position
				new_bullet.dir = new_bullet.global_position.direction_to(target).rotated(angle)
				new_bullet.type = bullet_type
				bullets.append(new_bullet)
			_change_state(STATE.COOLDOWN)
			cooldown_timer.start()
			fired.emit()
	return bullets

func _change_state(new_state: STATE) -> void:
	state = new_state
	match state:
		STATE.READY:
			ready_to_fire.emit()
