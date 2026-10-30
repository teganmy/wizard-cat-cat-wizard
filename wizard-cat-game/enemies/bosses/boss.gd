extends CharacterBody2D

@export var def: BossDef
@export_group("Wiring")
@export var health: Health
@export var shooter: AreaShooter
@export var nav_agent: NavigationAgent2D
@export var sprite: Sprite2D

var attack_timing: float
var attacks: Array[BossAttack]
var move_speed: float
var target_group: String
var min_target_distance:float
var max_target_distance:float
var distance_tolerance: float
var attack_distance: float
var flash_modulate: Color
var default_modulate: Color

var target: Node2D
var last_target_pos: Vector2 = Vector2.ZERO
var attack_timer: Timer

signal defeated

func _ready() -> void:
	attack_timing = def.attack_timing
	attacks = def.attacks
	move_speed = def.move_speed
	target_group = def.target_group
	min_target_distance = def.min_target_distance
	max_target_distance = def.max_target_distance
	distance_tolerance = def.distance_tolerance
	attack_distance = def.attack_distance
	flash_modulate = def.flash_modulate
	health.max_health = def.max_health
	default_modulate = def.modulate
	sprite.texture = def.sprite
	sprite.modulate = default_modulate
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_timing
	attack_timer.timeout.connect(_attack)
	add_child(attack_timer)
	attack_timer.start()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group)
	var max_error: float = global_position.distance_to(target.global_position) - max_target_distance
	var min_error: float = min_target_distance - global_position.distance_to(target.global_position)
	if max_error > distance_tolerance:
		if target.global_position.distance_to(last_target_pos) > 10.0:
			nav_agent.target_position = target.global_position
			last_target_pos = target.global_position
		velocity = global_position.direction_to(nav_agent.get_next_path_position()) * move_speed
	elif min_error > distance_tolerance:
		if target.global_position.distance_to(last_target_pos) > 10.0:
			var backoff_dir = - global_position.direction_to(target.global_position)
			var backoff_distance = min_target_distance - global_position.distance_to(target.global_position)
			nav_agent.target_position = global_position + (backoff_dir * backoff_distance)
		velocity = global_position.direction_to(nav_agent.get_next_path_position()) * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _attack() -> void:
	if global_position.distance_to(target.global_position) < attack_distance:
		var attack = attacks.pick_random()
		shooter.configure(attack.bullet, attack.pattern)
		for bullet in shooter.fire(target.global_position):
			add_sibling(bullet)


func _on_health_died() -> void:
	defeated.emit()
	queue_free()

func _on_health_changed(_current: int) -> void:
	_flash()

func _flash() -> void:
	modulate = flash_modulate
	create_tween().tween_property(self, "modulate", default_modulate, 0.2)
