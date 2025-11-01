extends Node
class_name Spawner

@export var tank_scene: PackedScene = preload("uid://b02jqorq8xrl5")
@onready var level_path: Path2D = $"../Level Path"

func _ready() -> void:
	spawn()

func spawn() -> void:
	var path_follow_2d: PathFollow2D = PathFollow2D.new()
	path_follow_2d.loop = false
	level_path.add_child(path_follow_2d)
	
	var tank = tank_scene.instantiate()
	path_follow_2d.add_child(tank)
