extends Area2D

export (PackedScene) var next_level;
	

func _on_Next_Level_body_entered(body):
	print("Det Next Level")
	if body.name != "Slime": return;
	print("Next Level!")
	get_tree().get_root().get_node("Game").next_level(next_level)
