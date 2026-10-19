class_name EnemyType
extends Resource

@export var sprite: Texture2D
@export var modulate: Color = Color.WHITE
@export var max_health: int = 1
@export_group("Shooting")
@export var bullet_type: BulletType
@export var wait_time: float = 1.0
@export var firing_pattern: FiringPattern
@export var detection_range: float = 400.0
@export var target_group: StringName = &"player"
@export_group("Movement")
@export var move_speed: float = 80.0
@export var preferred_distance: float = 220.0
@export var distance_tolerance: float = 30.0
@export_group("Loot")
@export var loot_table: Array[WeightedLoot]
@export var max_loot: int = 1
@export var min_loot: int = 0
