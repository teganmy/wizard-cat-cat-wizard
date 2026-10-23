class_name LevelDef
extends Resource

@export var name: String
@export_file("*.tscn") var file: String
@export var ordering: int
@export_group("Properties")
@export var icon: Texture2D
@export_multiline("Level description") var description: String
