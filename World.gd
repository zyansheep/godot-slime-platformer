extends TileMap

func _ready():
	#load frosty buttons
	print("loading")
	for tile in get_used_cells_by_id(tile_set.find_tile_by_name("torch")):
		#var torch = preload("res://interactives/Torch.tscn").instance()
		#torch.position = map_to_world(tile);
		#torch.position += Vector2(8,8);
		#add_child(torch)
		print("adding torch")
		
		
	
