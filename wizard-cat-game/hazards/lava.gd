extends Polygon2D

@export var damage: int = 1

@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	hitbox.damage = damage
	$Hitbox/CollisionPolygon2D.polygon = polygon
