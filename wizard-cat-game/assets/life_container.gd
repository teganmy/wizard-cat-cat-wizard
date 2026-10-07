extends HBoxContainer

var hearts: Array[TextureRect] = []
@export var texture: Texture2D
var got_player: bool = false

func _process(_delta: float) -> void:
	if not got_player:
		try_get_player()

func change_hearts(new: int) -> void:
	var heart_size := hearts.size()
	if heart_size > new:
		for _i in range(heart_size - new):
			var heart = hearts.pop_back()
			heart.queue_free()
	elif heart_size < new:
		for _i in range(new - heart_size):
			var heart = TextureRect.new()
			heart.texture = texture
			add_child(heart)
			hearts.push_back(heart)

func try_get_player() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		if player:
			player.health.changed.connect(change_hearts)
			change_hearts(player.health.max_health)
			got_player = true
			return
	return
