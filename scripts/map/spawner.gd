extends Node
class_name Spawner

@export var level_data: LevelData

@onready var level_path: Path2D = $"../Level Path"
@onready var spawner_cooldown: Timer = $"../SpawnerCooldown"

func _ready() -> void:
	spawn_next_wave()

func spawn_next_wave() -> void:
	var wave: WaveData = level_data.waves[0]
	
	for part in wave.parts:
		var tank_scene: PackedScene = part.unit
		
		for i in range(part.times):
			var path_follow_2d: PathFollow2D = PathFollow2D.new()
			path_follow_2d.loop = false
			level_path.add_child(path_follow_2d)
			
			var tank = tank_scene.instantiate()
			path_follow_2d.add_child(tank)
			
			spawner_cooldown.start(part.delay_in_spawns)
			await spawner_cooldown.timeout
