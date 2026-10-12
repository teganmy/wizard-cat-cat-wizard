extends HBoxContainer

var hearts: Array[TextureRect] = []
var max_health = 0
var current_health = 0
@export var heart_texture: Texture2D

func change_hearts(new: int) -> void:
	pass

func change_max(new: int) -> void:
	max_health = new
	hearts.clear()
	for _i in range(new):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		hearts.push_back(heart)
		add_child(heart)
	change_hearts(new)

func _ready() -> void:
	change_max(PlayerState.max_health)
	PlayerState.max_health_changed.connect(_on_player_max_changed)

func _on_player_max_changed(new: int) -> void:
	change_max(new)
