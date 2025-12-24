extends Camera2D

@export var right_boundry_node: Node2D
@export var bottom_boundry_node: Node2D

# Boudries
var top_boundry: Vector2 = Vector2(0, 0)
var left_boundry: Vector2 = Vector2(0, 0)
var right_boundry: Vector2
var bottom_boundry: Vector2

var max_zoom = 2
var min_zoom = 0.3

# constants
const ZOOM_SCALE = 1.05

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var val = min((zoom * ZOOM_SCALE).x, max_zoom)
			zoom = Vector2(val, val)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var val = max((zoom / ZOOM_SCALE).x, min_zoom)
			zoom = Vector2(val, val)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	right_boundry = right_boundry_node.global_position
	bottom_boundry = bottom_boundry_node.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
