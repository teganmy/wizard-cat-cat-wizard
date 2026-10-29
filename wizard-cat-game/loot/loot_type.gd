class_name LootType
extends Resource

@export var name: String
@export var sprite: Texture2D
@export var value: int = 1
@export var tint: Color = Color.WHITE
@export var heal_amount: int = 0
@export var fire_rate_multiplier: float = 1.0
@export var fire_rate_duration: float = 0.0
@export var attack: SecondaryAttack
