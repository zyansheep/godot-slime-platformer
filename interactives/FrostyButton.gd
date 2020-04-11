extends StaticBody2D

signal pressed;

func _on_Area_body_entered(body):
	if body.name == "Slime":
		if body.cur_state == body.heavy:
			$Sprite.frame = 1
			$CollisionShape2D.position = Vector2(0,4)
			emit_signal("pressed")


func _on_Area_body_exited(_body):
	pass # Replace with function body.
