extends HBoxContainer

var hearts: Array[TextureRect] = []
@export var heart_texture: Texture2D

func change_hearts(new: int) -> void:
	for i in hearts.size():
		hearts[i].modulate = Color.WHITE if i < new else Color.BLACK
		

func change_max(new: int) -> void:
	for heart in hearts:
		remove_child(heart)
		heart.queue_free()
	hearts.clear()
	for _i in range(new):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		hearts.push_back(heart)
		add_child(heart)
		heart.offset_transform_enabled = true
		heart.offset_transform_scale = Vector2(2.0,2.0)
	change_hearts(PlayerState.current_health)

func _ready() -> void:
	change_max(PlayerState.max_health)
	PlayerState.max_health_changed.connect(_on_player_max_changed)
	PlayerState.current_health_changed.connect(_on_player_current_changed)

func _on_player_max_changed(new: int) -> void:
	change_max(new)
	change_hearts(new)

func _on_player_current_changed(new: int) -> void:
	change_hearts(new)
