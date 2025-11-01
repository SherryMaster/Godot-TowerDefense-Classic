@tool
extends Path2D

@export_tool_button("Make Path") var make_path_button: Callable = make_path
@export var ease_offset := 30
@export var point_offset := 56

@onready var starting_position: Marker2D = $"Starting Position"
@onready var road: TileMapLayer = $"../Map/Road"

var path_points: Array[Vector2i]

var road_turns_atlas_cords:Dictionary[String, Vector2i] = {
	"top_right": Vector2i(1, 0),
	"right_down": Vector2i(3, 0),
	"down_left": Vector2i(3, 2),
	"left_top": Vector2i(1, 2),
}

# Ends: up, down, left, righ
var road_ends:Dictionary[String, Vector2i] = {
	"top": Vector2i(0, 0),
	"down": Vector2i(0, 2),
	"left": Vector2i(1, 3),
	"right": Vector2i(3, 3),
}

var current_direction: String = "none"
var current_tile_cords: Vector2i

#func _ready() -> void:
	#make_path()

func make_path():
	path_points = []
	process_start_tile()
	
	#safty
	var MAX_ITTERS = 1000
	while (road.get_cell_atlas_coords(current_tile_cords) not in road_ends.values() or path_points.size() < 2) and MAX_ITTERS > 0:
		process_path()
		MAX_ITTERS -= 1
	
	make_path_curve()

func process_start_tile():
	var tile_cords := road.local_to_map(starting_position.global_position)
	var cords := road.get_cell_atlas_coords(tile_cords)
	path_points.append(tile_cords)
	
	current_direction = "top" if cords == road_ends["down"] else "down" if cords == road_ends["top"] \
		else "left" if cords == road_ends["right"] else "right"
	
	current_tile_cords = tile_cords

func process_path():
	"""
	Will mark the next possible turn
	0 - The path is now at end
	1 - The turn is processed further path can be processed
	"""
	var turn_atles_tile_cords = road_turns_atlas_cords.values()
	
	while true:
		if road.get_cell_tile_data(current_tile_cords):
			if road.get_cell_atlas_coords(current_tile_cords) not in turn_atles_tile_cords or current_tile_cords in path_points:
				current_tile_cords += Vector2i(0,-1) if current_direction == "top" \
								else Vector2i(0,1) if current_direction == "down" \
								else Vector2i(-1,0) if current_direction == "left" \
								else Vector2i(1,0)
			else:
				var detected_turn_atlas_cords = road.get_cell_atlas_coords(current_tile_cords)
		
				current_direction = "top" if (detected_turn_atlas_cords == road_turns_atlas_cords["left_top"] and current_direction == "left") or (detected_turn_atlas_cords == road_turns_atlas_cords["down_left"] and current_direction == "right") \
					else "down" if (detected_turn_atlas_cords == road_turns_atlas_cords["top_right"] and current_direction == "left") or (detected_turn_atlas_cords == road_turns_atlas_cords["right_down"] and current_direction == "right") \
					else "left" if (detected_turn_atlas_cords == road_turns_atlas_cords["right_down"] and current_direction == "top") or (detected_turn_atlas_cords == road_turns_atlas_cords["down_left"] and current_direction == "down") \
					else "right"
				break
		else:
			current_tile_cords -= Vector2i(0,-1) if current_direction == "top" \
						else Vector2i(0,1) if current_direction == "down" \
						else Vector2i(-1,0) if current_direction == "left" \
						else Vector2i(1,0)
			break
	
	
	path_points.append(current_tile_cords)

func make_path_curve():
	curve = null
	var new_curve = Curve2D.new()
	
	for i in range(path_points.size()):
		var point = path_points[i]
		
		var map_position_point:Vector2 = road.map_to_local(point)
		
		var atlas_point = road.get_cell_atlas_coords(point)
		
		
		if point != path_points[0] and point != path_points[-1]: # make sure it's not the start and end point the rest are turns
			var point_out: Vector2 = Vector2(0, -ease_offset) if atlas_point == road_turns_atlas_cords["top_right"] else Vector2(ease_offset, 0) if atlas_point == road_turns_atlas_cords["right_down"] else Vector2(0, ease_offset) if atlas_point == road_turns_atlas_cords["down_left"] else Vector2(-ease_offset, 0)
			var point_in: Vector2 = Vector2(-ease_offset, 0) if atlas_point == road_turns_atlas_cords["top_right"] else Vector2(0, -ease_offset) if atlas_point == road_turns_atlas_cords["right_down"] else Vector2(ease_offset, 0) if atlas_point == road_turns_atlas_cords["down_left"] else Vector2(0, ease_offset)
			
			var position1_offset = Vector2(0, point_offset) if atlas_point == road_turns_atlas_cords["top_right"] else Vector2(-point_offset, 0) if atlas_point == road_turns_atlas_cords["right_down"] else Vector2(0, -point_offset) if atlas_point == road_turns_atlas_cords["down_left"] else Vector2(point_offset, 0)
			var position2_offset = Vector2(point_offset, 0) if atlas_point == road_turns_atlas_cords["top_right"] else Vector2(0, point_offset) if atlas_point == road_turns_atlas_cords["right_down"] else Vector2(-point_offset, 0) if atlas_point == road_turns_atlas_cords["down_left"] else Vector2(0, -point_offset)
			
			var direction = "top" if point.y < path_points[i - 1].y and point.x == path_points[i-1].x \
						else "down" if point.y > path_points[i - 1].y and point.x == path_points[i-1].x \
						else "left" if point.y == path_points[i - 1].y and point.x < path_points[i-1].x \
						else "right" if point.y == path_points[i - 1].y and point.x > path_points[i-1].x \
						else "none"
			
			if direction == "top" and atlas_point == road_turns_atlas_cords["top_right"] or\
				direction == "right" and atlas_point == road_turns_atlas_cords["right_down"] or\
				direction == "down" and atlas_point == road_turns_atlas_cords["down_left"] or\
				direction == "left" and atlas_point == road_turns_atlas_cords["left_top"]:
					
				new_curve.add_point(map_position_point + position1_offset, -point_out, point_out)
				new_curve.add_point(map_position_point + position2_offset, point_in, -point_in)
			
			else:
				new_curve.add_point(map_position_point + position2_offset, -point_in, point_in)
				new_curve.add_point(map_position_point + position1_offset, point_out, -point_out)
			
		else:
			new_curve.add_point(map_position_point)
	
	curve = new_curve
	
	
