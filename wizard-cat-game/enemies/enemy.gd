class_name Enemy
extends CharacterBody2D
signal died

@export var health: Health
@export var shooter: AreaShooter
@export_group("Shooting")
@export var wait_time: float = 1.0
@export var firing_pattern: FiringPattern
@export var detection_range: float = 400.0
@export var target_group: StringName = &"player"
@export_group("Movement")
@export var move_speed: float = 80.0
@export var preferred_distance: float = 220.0
@export var distance_tolerance: float = 30.0

var target: Node2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	health.changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	if firing_pattern:
		shooter.firing_pattern = firing_pattern
	var wait_timer = Timer.new()
	wait_timer.wait_time = wait_time
	wait_timer.autostart = true
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	add_child(wait_timer)
	await get_tree().physics_frame


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group) as Node2D
		return

	var error := global_position.distance_to(target.global_position) - preferred_distance
	velocity = Vector2.ZERO

	if error > distance_tolerance:    
		nav.target_position = target.global_position
		velocity = global_position.direction_to(nav.get_next_path_position()) * move_speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func _on_wait_timer_timeout() -> void:
	if not is_instance_valid(target):
		return
	if global_position.distance_to(target.global_position) > detection_range:
		return
	shoot()

func shoot() -> void:
	for bullet in shooter.fire(target.global_position):
		add_sibling(bullet)
		bullet.global_position = shooter.global_position

func _on_health_changed(current: int) -> void:
	if current < health.max_health:
		_flash()

func _on_died() -> void:
	died.emit()
	$Lootable.generate_loot()
	queue_free()

func _flash() -> void:
	modulate = Color(1, 0.4, 0.4)
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.15)
