extends CharacterBody2D

@export var def: BossDef
@export_group("Wiring")
@export var health: Health
@export var shooter: AreaShooter
@export var nav_agent: NavigationAgent2D
@export var sprite: Sprite2D

@export_group("Temp tuning") # TODO: Read these from boss def
@export var attack_timing: float = 1.0
@export var attacks: Array[BossAttack] = []
@export var move_speed: float = 100.0
@export var target_group: String = &"player"
@export var min_target_distance:float = 100.0
@export var max_target_distance:float = 200.0
@export var distance_tolerance: float = 10.0

var target: Node2D
var last_target_pos: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group)
	var max_error: float = global_position.distance_to(target.global_position) - max_target_distance
	var min_error: float = min_target_distance - global_position.distance_to(target.global_position)
	if max_error > distance_tolerance:
		if target.global_position.distance_to(last_target_pos) > 5.0:
			nav_agent.target_position = target.global_position
			last_target_pos = target.global_position
		velocity = global_position.direction_to(nav_agent.get_next_path_position()) * move_speed
	elif min_error > distance_tolerance:
		if target.global_position.distance_to(last_target_pos) > 5.0:
			var backoff_dir = - global_position.direction_to(target.global_position)
			var backoff_distance = min_target_distance - global_position.distance_to(target.global_position)
			nav_agent.target_position = global_position + (backoff_dir * backoff_distance)
		velocity = global_position.direction_to(nav_agent.get_next_path_position()) * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
