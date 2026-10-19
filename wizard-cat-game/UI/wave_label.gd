extends Label

var tween: Tween

func _ready() -> void:
	hide()
	modulate.a = 0
	RoomState.activated.connect(_on_room_activated)
	RoomState.wave.connect(_on_room_wave)
	RoomState.defeated.connect(_on_room_defeated)

func _on_room_activated() -> void:
	show()

func _on_room_wave(wave: int) -> void:
	text = "Wave %s" % wave
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(3.0)
	
func _on_room_defeated() -> void:
	hide()
