extends CharacterBody2D

@export var speed: float = 100
@export var dodge_speed: float = 500
@onready var shooter := $Shooter
@onready var sprite := $Sprite2D
@onready var health := $Health
@onready var dodge_cooldown := $DodgeCooldown
@onready var hurtbox := $Hurtbox
var last_dir: Vector2 = Vector2.ZERO
var dodge_dir: Vector2 = Vector2.ZERO
signal died

enum STATE {IDLE, MOVE, DODGE}
var state: STATE = STATE.IDLE

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if Input.is_action_just_pressed("fire"):
		add_sibling(shooter.fire(get_global_mouse_position()))
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	match state:
		STATE.IDLE:
			if dir != Vector2.ZERO:
				_change_state(STATE.MOVE)
			if Input.is_action_just_pressed("player_dodge"):
				_change_state(STATE.DODGE)
		STATE.MOVE:
			if dir == Vector2.ZERO:
				_change_state(STATE.IDLE)
			if Input.is_action_just_pressed("player_dodge"):
				_change_state(STATE.DODGE)
			if dir != last_dir:
				get_tree().create_tween().set_trans(Tween.TRANS_QUAD).tween_property(self, "velocity", speed * dir, 0.1)
				last_dir = dir
		STATE.DODGE:
			velocity = dodge_dir * dodge_speed
	move_and_slide()

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.IDLE:
			pass
		STATE.MOVE:
			pass
		STATE.DODGE:
			if dodge_cooldown.is_stopped():
				_dodge()
			else:
				_change_state(STATE.IDLE)

func _dodge() -> void:
	hurtbox.monitoring = false
	hurtbox.monitorable = false
	dodge_dir = -global_position.direction_to(get_global_mouse_position())
	get_tree().create_timer(0.1).timeout.connect(_end_dodge)

func _end_dodge() -> void:
	velocity = Vector2.ZERO
	hurtbox.monitoring = true
	hurtbox.monitorable = true
	dodge_cooldown.start()
	_change_state(STATE.IDLE)

func _on_health_died() -> void:
	health.heal(health.max_health)
	died.emit()
