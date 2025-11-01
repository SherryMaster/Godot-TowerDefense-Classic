extends CharacterBody2D
class_name BaseTank

@export var speed = 500
@export var health = 20

var path_follow_2d: PathFollow2D

func _ready() -> void:
	path_follow_2d = get_parent() as PathFollow2D

func _process(delta: float) -> void:
	path_follow_2d.progress += speed * delta
	
	if path_follow_2d.progress_ratio == 1:
		destroy()

func destroy():
	queue_free()
