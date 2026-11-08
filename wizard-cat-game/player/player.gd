extends CharacterBody2D

const GROUND_RESPONSE := 0.1
const FEET_OFFSET := Vector2(0, 8)
@export var ice_slide_time: float = 1.0
@export var water_speed_multiplier: float = 0.5
@export var speed: float = 100
@export var dodge_speed: float = 500
@export var dodge_time: float = 0.2
@export var i_frames: float = 0.1
@onready var shooter := $AreaShooter
@onready var sprite := $Sprite2D
@onready var health := $Health
@onready var dodge_cooldown := $DodgeCooldown
@onready var hurtbox := $Hurtbox
@onready var secondary_shooter: AreaShooter = $SecondaryShooter
@onready var pickup_area: PickupArea = $PickupArea
@onready var camera: Camera2D = $Camera2D
@export_group("Visuals")
@export var hit_shake: float = 100.0
@export var dodge_shake: float = 20.0

var last_dir: Vector2 = Vector2.ZERO
var dodge_dir: Vector2 = Vector2.ZERO
var _surface_layer: TileMapLayer

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
	_surface_layer = get_tree().get_first_node_in_group("surface_layer")

func _process(_delta: float) -> void:
	if get_global_mouse_position().x < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if Input.is_action_just_pressed("fire"):
		for bullet in shooter.fire(get_global_mouse_position()):
			add_sibling(bullet)
	if Input.is_action_just_pressed("secondary_fire"):
		for bullet in secondary_shooter.fire(get_global_mouse_position()):
			add_sibling(bullet)
	if Input.is_action_just_pressed("use_potion"):
		_use_potion()
	if Input.is_action_just_pressed("cycle_potion"):
		PlayerState.cycle_potion()
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
			last_dir = dir
		STATE.DODGE:
			velocity = dodge_dir * dodge_speed
	if state != STATE.DODGE:
		_update_velocity(dir, delta)
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
	get_tree().create_timer(dodge_time).timeout.connect(_end_dodge)
	_flash(dodge_time * 2)
	camera.shake(dodge_shake)

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
	_flash(i_frames / 5, 5)
	camera.shake(hit_shake)
	
func _use_potion() -> void:
	var potion: LootType = PlayerState.selected()
	if potion == null or not potion.can_use(health):
		return
	pickup_area.apply_effect(potion)
	PlayerState.consume_selected()
	
func _update_velocity(dir: Vector2, delta: float) -> void:
	var max_speed := speed
	var accel_time := GROUND_RESPONSE
	var stop_time := GROUND_RESPONSE
	match _get_surface():
		"ice":
			accel_time = ice_slide_time * 0.4
			stop_time = ice_slide_time
		"water":
			max_speed = speed * water_speed_multiplier
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir * max_speed, speed / accel_time * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed / stop_time * delta)

func _get_surface() -> String:
	if _surface_layer == null:
		return ""
	var cell := _surface_layer.local_to_map(_surface_layer.to_local(global_position + FEET_OFFSET))
	var data := _surface_layer.get_cell_tile_data(cell)
	if data == null:
		return ""
	return str(data.get_custom_data("surface"))

func _flash(time: float, repeats:int = 1, color: Color = Color.WHITE) -> void:
	var sprite_material: ShaderMaterial = sprite.material
	sprite_material.set_shader_parameter("solid_color", color)
	for _i in range(repeats):
		sprite_material.set_shader_parameter("on", true)
		await get_tree().create_timer(time / 2).timeout
		sprite_material.set_shader_parameter("on", false)
		await get_tree().create_timer(time / 2).timeout
