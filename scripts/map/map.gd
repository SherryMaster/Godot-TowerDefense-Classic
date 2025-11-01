@tool
extends Node2D
class_name LevelMap

@export_tool_button("Add Road Placement Ristrictions") var callable: Callable = put_road_placeholder_tiles
@export_tool_button("Add Ground Placement Locations") var callable2: Callable = put_ground_placegolders
@export_tool_button("Clear Placeholders") var callable3: Callable = clear_placeholders

@onready var road: TileMapLayer = $Road
@onready var ground: TileMapLayer = $Ground
@onready var placement_tiles: TileMapLayer = $PlacementTiles

#func _ready():
	#placement_tiles.modulate.a = 0

func clear_placeholders():
	placement_tiles.clear()

func put_road_placeholder_tiles():
	var road_tiles := road.get_used_cells()
	
	for tile in road_tiles:
		var tile_pos := road.map_to_local(tile)
		
		var top_left_tile := placement_tiles.local_to_map(tile_pos + Vector2(-32, -32))
		var top_right_tile := placement_tiles.local_to_map(tile_pos + Vector2(32, -32))
		var bottom_left_tile := placement_tiles.local_to_map(tile_pos + Vector2(-32, 32))
		var bottom_right_tile := placement_tiles.local_to_map(tile_pos + Vector2(32, 32))
		
		
		placement_tiles.set_cell(top_left_tile, 0, Vector2i(1, 0))
		placement_tiles.set_cell(top_right_tile, 0, Vector2i(1, 0))
		placement_tiles.set_cell(bottom_left_tile, 0, Vector2i(1, 0))
		placement_tiles.set_cell(bottom_right_tile, 0, Vector2i(1, 0))
		
func put_ground_placegolders():
	var road_tiles := road.get_used_cells()
	
	var ground_tiles: Array[Vector2i]= []
	
	for tile in ground.get_used_cells():
		if tile not in road_tiles:
			ground_tiles.append(tile)
	
	for tile in ground_tiles:
		var tile_pos := road.map_to_local(tile)
		
		var top_left_tile := placement_tiles.local_to_map(tile_pos + Vector2(-32, -32))
		var top_right_tile := placement_tiles.local_to_map(tile_pos + Vector2(32, -32))
		var bottom_left_tile := placement_tiles.local_to_map(tile_pos + Vector2(-32, 32))
		var bottom_right_tile := placement_tiles.local_to_map(tile_pos + Vector2(32, 32))
		
		
		placement_tiles.set_cell(top_left_tile, 0, Vector2i(0, 0))
		placement_tiles.set_cell(top_right_tile, 0, Vector2i(0, 0))
		placement_tiles.set_cell(bottom_left_tile, 0, Vector2i(0, 0))
		placement_tiles.set_cell(bottom_right_tile, 0, Vector2i(0, 0))
