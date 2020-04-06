extends TileMap



func _ready():
	#load frosty buttons
	for tile in get_used_cells_by_id(tile_set.find_tile_by_name("frosty-button")):
		var frosty_button = preload("res://interactives/FrostyButton.tscn").instance()
		frosty_button.position = map_to_world(tile);
		add_child(frosty_button)
	
