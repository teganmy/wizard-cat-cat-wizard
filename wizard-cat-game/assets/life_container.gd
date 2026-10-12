extends HBoxContainer

var hearts: Array[TextureRect] = []
@export var heart_texture: Texture2D

func change_hearts(new: int) -> void:
	for heart in range(0, new):
		hearts[heart].show()
	for heart in range(new, PlayerState.max_health):
		hearts[heart].hide()

func change_max(new: int) -> void:
	hearts.clear()
	for _i in range(new):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.hide()
		hearts.push_back(heart)
		add_child(heart)
	change_hearts(PlayerState.current_health)

func _ready() -> void:
	change_max(PlayerState.max_health)
	PlayerState.max_health_changed.connect(_on_player_max_changed)
	PlayerState.current_health_changed.connect(_on_player_current_changed)

func _on_player_max_changed(new: int) -> void:
	change_max(new)

func _on_player_current_changed(new: int) -> void:
	change_hearts(new)
