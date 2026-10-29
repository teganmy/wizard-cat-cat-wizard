extends CharacterBody2D

@export var speed: float = 100
@export var dodge_speed: float = 500
@export var i_frames: float = 0.1
@onready var shooter := $AreaShooter
@onready var sprite := $Sprite2D
@onready var health := $Health
@onready var dodge_cooldown := $DodgeCooldown
@onready var hurtbox := $Hurtbox
@onready var secondary_shooter: AreaShooter = $SecondaryShooter
var last_dir: Vector2 = Vector2.ZERO
var dodge_dir: Vector2 = Vector2.ZERO

enum STATE {IDLE, MOVE, DODGE}
enum HIT_STATE {NORMAL, INVINCIBLE}
var state: STATE = STATE.IDLE
var hit_state: HIT_STATE = HIT_STATE.NORMAL
var iframe_timer: Timer

func _ready() -> void:
	if not PlayerState.max_health:
		PlayerState.max_health = health.max_health
	else:
		health.set_max(PlayerState.max_health)
	PlayerState.current_health = health.current
	health.changed.connect(func(new: int): PlayerState.current_health = new)
	iframe_timer = Timer.new()
	iframe_timer.wait_time = i_frames
	iframe_timer.one_shot = true
	iframe_timer.timeout.connect(_change_hit_state.bind(HIT_STATE.NORMAL))
	add_child(iframe_timer)

func _process(_delta: float) -> void:
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if Input.is_action_just_pressed("fire"):
		for bullet in shooter.fire(get_global_mouse_position()):
			add_sibling(bullet)
	if Input.is_action_just_pressed("secondary_fire"):
		for bullet in secondary_shooter.fire(get_global_mouse_position()):
			add_sibling(bullet)
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
				create_tween().set_trans(Tween.TRANS_QUAD).tween_property(self, "velocity", speed * dir, 0.1)
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

func _change_hit_state(new_state: HIT_STATE) -> void:
	hit_state = new_state
	match new_state:
		HIT_STATE.NORMAL:
			hurtbox.set_deferred("monitoring", true)
			hurtbox.set_deferred("monitorable", true)
		HIT_STATE.INVINCIBLE:
			hurtbox.set_deferred("monitoring", false)
			hurtbox.set_deferred("monitorable", false)
			iframe_timer.start()

func _dodge() -> void:
	_change_hit_state(HIT_STATE.INVINCIBLE)
	dodge_dir = last_dir
	get_tree().create_timer(0.1).timeout.connect(_end_dodge)

func _end_dodge() -> void:
	velocity = Vector2.ZERO
	dodge_cooldown.start()
	_change_hit_state(HIT_STATE.NORMAL)
	_change_state(STATE.IDLE)
	last_dir = Vector2.ZERO


func _on_pickup_area_picked_up(value: int) -> void:
	PlayerState.currency += value


func _on_hurtbox_hurt() -> void:
	_change_hit_state(HIT_STATE.INVINCIBLE)
	modulate = Color.DARK_GRAY
	create_tween().tween_property(self, "modulate", Color.WHITE, i_frames)
