extends Area2D

export (Shape2D) var detector_shape;
export (PackedScene) var next_level;

func _ready():
	$CollisionShape2D.shape = detector_shape;
	

func _on_Next_Level_body_entered(body):
	if body.name != "Slime": return;
	print("Next Level!")
	get_tree().get_root().get_node("Game").next_level(next_level)
