extends Node2D

func _input(_event):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func next_level(level_resource):
	print("Next Level")
	call_deferred("_next_level_deferred", level_resource)

func _next_level_deferred(level_resource):
	var level = get_node("Level")
	remove_child(level)
	level.call_deferred("free")
	add_child(level_resource.instance())
