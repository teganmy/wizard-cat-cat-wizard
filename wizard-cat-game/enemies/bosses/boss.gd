extends CharacterBody2D

@export var def: BossDef
@export_group("Wiring")
@export var health: Health
@export var shooter: AreaShooter
@export var nav_agent: NavigationAgent2D
@export var sprite: Sprite2D
@export var death_particles: GPUParticles2D
@export var lootable: Lootable

var boss_name: String
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

enum STATE {ALIVE, DEAD}
var state: STATE = STATE.ALIVE
var shake_mult: float = 0.0

func _ready() -> void:
	boss_name = def.name
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
	health.current = def.max_health
	default_modulate = def.modulate
	sprite.texture = def.sprite
	sprite.modulate = default_modulate
	lootable.loot_table = def.loot_table
	lootable.max_amount = def.max_loot
	lootable.min_amount = def.min_loot
	lootable.guaranteed_loot = def.guaranteed_loot
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_timing
	attack_timer.timeout.connect(_attack)
	add_child(attack_timer)
	attack_timer.start()

func _physics_process(_delta: float) -> void:
	match state:
		STATE.ALIVE:
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
		STATE.DEAD:
			velocity = Vector2.ZERO
			sprite.offset = Vector2(randf_range(0.0, 5.0), randf_range(0.0, 5.0)) * shake_mult
	move_and_slide()

func _attack() -> void:
	match state:
		STATE.ALIVE:
			if global_position.distance_to(target.global_position) < attack_distance:
				var attack = attacks.pick_random()
				shooter.configure(attack.bullet, attack.pattern)
				for bullet in shooter.fire(target.global_position):
					add_sibling(bullet)
					bullet.global_position = shooter.global_position


func _on_health_died() -> void:
	match state:
		STATE.ALIVE:
			_change_state(STATE.DEAD)
			var tween = create_tween()
			tween.tween_property(self, "shake_mult", 1.0, 1.0)
			tween.parallel().tween_property(sprite, "modulate", Color.BLACK, 2.0).set_delay(0.5)
			tween.parallel().tween_property(sprite, "scale", Vector2(0.1, 0.25), 2.0).set_delay(0.5)
			await tween.finished
			sprite.hide()
			death_particles.emitting = true
			defeated.emit()
			lootable.generate_loot()
			await death_particles.finished
			queue_free()

func _on_health_changed(_current: int) -> void:
	match state:
		STATE.ALIVE:
			_flash()

func _flash() -> void:
	modulate = flash_modulate
	create_tween().tween_property(self, "modulate", default_modulate, 0.2)

func _change_state(new_state: STATE) -> void:
	state = new_state
