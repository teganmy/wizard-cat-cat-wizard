class_name BulletType
extends Resource

@export_group("Visuals")
@export var sprite: Texture2D
@export var particle_texture: Texture2D
@export var modulate: Color = Color.WHITE
@export var particle_modulate: Color
@export_group("Behavior")
@export var speed: float = 200.0
@export_range(0.0, 10.0, 0.1, "suffix:s") var lifetime: float = 1.0
@export var speed_curve: Curve
@export var damage: int = 1
@export_subgroup("Collision")
@export_flags_2d_physics var collision_layer
@export_flags_2d_physics var collision_mask
@export_flags_2d_physics var hitbox_layer
@export_flags_2d_physics var hitbox_mask
@export_group("Transform")
@export_custom(PROPERTY_HINT_LINK, "") var scale: Vector2 = Vector2(1.0,1.0)
@export_group("Overrides")
@export var custom_bullet_scene: PackedScene
