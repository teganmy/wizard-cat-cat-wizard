class_name BossDef
extends Resource

@export var name: String
@export var sprite: Texture2D
@export var modulate: Color = Color.WHITE

@export_group("Attacking")
@export var attack_timing: float
@export var attacks: Array[BossAttack] = []
@export var attack_distance: float

@export_group("Moving")
@export var target_group: String = &"player"
@export var move_speed: float
@export var min_target_distance: float
@export var max_target_distance: float
@export var distance_tolerance: float

@export_group("Health")
@export var max_health: int
@export var flash_modulate: Color

@export_group("Loot")
@export var loot_table: Array[WeightedLoot]
@export var max_loot: int
@export var min_loot: int
@export var guaranteed_loot: Array[LootType]
