class_name Enemy
extends CharacterBody2D
signal died

@export var health: Health
@export var shooter: AreaShooter
@export var type: EnemyType
@export var trail_particles: GPUParticles2D
var wait_time: float = 0.5
var detection_range: float = 400.0
var target_group: StringName = &"player"
var move_speed: float = 80.0
var preferred_distance: float = 220.0
var distance_tolerance: float = 30.0
var default_modulate: Color = Color.WHITE
var spawn_particle_color: Color = Color.WHITE
var charge_speed: float
var charge_time: float
var dir: Vector2 = Vector2.ZERO
var charge_timer: Timer
var wait_timer: Timer

var target: Node2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sprite := $Sprite2D
@onready var particles := $GPUParticles2D
@onready var lootable := $Lootable
@export var hitbox: Hitbox

enum COMBAT_TYPE {SHOOTER, CHARGER}
var combat_type: COMBAT_TYPE

enum STATE {NORMAL, CHARGING}
var state: STATE = STATE.NORMAL

func _ready() -> void:
	health.changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	wait_time = type.wait_time
	detection_range = type.detection_range
	target_group = type.target_group
	move_speed = type.move_speed
	wait_timer = Timer.new()
	if type.shooter:
		_set_combat_type(COMBAT_TYPE.SHOOTER)
	elif type.charger:
		_set_combat_type(COMBAT_TYPE.CHARGER)
	match combat_type:
		COMBAT_TYPE.SHOOTER:
			shooter.firing_pattern = type.firing_pattern
			shooter.bullet_type = type.bullet_type
			shooter.setup_pattern()
		COMBAT_TYPE.CHARGER:
			charge_speed = type.charge_speed
			charge_time = type.charge_time
			charge_timer = Timer.new()
			charge_timer.wait_time = charge_time
			charge_timer.one_shot = true
			charge_timer.timeout.connect(_change_state.bind(STATE.NORMAL))
			add_child(charge_timer)
	wait_timer.wait_time = wait_time
	preferred_distance = type.preferred_distance
	distance_tolerance = type.distance_tolerance
	health.set_max(type.max_health)
	sprite.texture = type.sprite
	trail_particles.texture = type.sprite
	modulate = type.modulate
	default_modulate = type.modulate
	particles.modulate = spawn_particle_color
	lootable.loot_table = type.loot_table
	lootable.max_amount = type.max_loot
	lootable.min_amount = type.min_loot
	hitbox.damage = type.contact_damage
	wait_timer.autostart = true
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	add_child(wait_timer)
	particles.emitting = true

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group) as Node2D
		return
	match state:
		STATE.NORMAL:
			var error := global_position.distance_to(target.global_position) - preferred_distance
			velocity = Vector2.ZERO
			
			if error > distance_tolerance:    
				nav.target_position = target.global_position
				velocity = global_position.direction_to(nav.get_next_path_position()) * move_speed
			else:
				velocity = Vector2.ZERO
		STATE.CHARGING:
			velocity = dir * charge_speed
		
	move_and_slide()

func _on_wait_timer_timeout() -> void:
	if not is_instance_valid(target):
		return
	if global_position.distance_to(target.global_position) > detection_range:
		return
	match combat_type:
		COMBAT_TYPE.SHOOTER:
			shoot()
		COMBAT_TYPE.CHARGER:
			charge()

func shoot() -> void:
	for bullet in shooter.fire(target.global_position):
		add_sibling(bullet)
		bullet.global_position = shooter.global_position

func charge() -> void:
	_change_state(STATE.CHARGING)
	dir = global_position.direction_to(target.global_position)
	charge_timer.start()

func _on_health_changed(current: int) -> void:
	if current < health.max_health:
		_flash()

func _on_died() -> void:
	died.emit()
	$Lootable.generate_loot()
	queue_free()

func _flash() -> void:
	modulate = Color(1, 0.4, 0.4)
	create_tween().tween_property(self, "modulate", default_modulate, 0.15)

func _process(_delta: float) -> void:
	if is_instance_valid(target):
		sprite.flip_h = target.global_position.x > global_position.x

func _set_combat_type(new: COMBAT_TYPE) -> void:
	combat_type = new

func _change_state(new: STATE) -> void:
	state = new
	match new:
		STATE.NORMAL:
			if wait_timer.is_stopped():
				wait_timer.start()
			sprite.set_instance_shader_parameter("instance_on", false)
			trail_particles.emitting = false
		STATE.CHARGING:
			wait_timer.stop()
			sprite.set_instance_shader_parameter("instance_on", true)
			trail_particles.emitting = true
