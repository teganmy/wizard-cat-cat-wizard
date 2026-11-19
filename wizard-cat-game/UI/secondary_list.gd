extends GridContainer


@export var draggable_scene: PackedScene

func reload() -> void:
	var secondaries = PlayerState.secondaries
	get_children().map(func(n: Node): n.queue_free())
	for secondary in secondaries:
		var panel = draggable_scene.instantiate()
		panel.set("def", secondary)
		add_child(panel)
