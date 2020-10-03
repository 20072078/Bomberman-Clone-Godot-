extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var list_of_tile_positions = []
var final_list_of_tile_positions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(0,len(get_used_cells())):
		list_of_tile_positions.append(map_to_world(get_used_cells()[i])) 
	
	for j in list_of_tile_positions:
		final_list_of_tile_positions.append(j + Vector2(32,32))


