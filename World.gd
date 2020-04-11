extends TileMap

func _ready():
	#load frosty buttons
	for tile in get_used_cells_by_id(tile_set.find_tile_by_name("spike")):
		var spike = preload("res://interactives/Spike.tscn").instance()
		spike.position = map_to_world(tile);
		add_child(spike)
		
	
