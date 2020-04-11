extends Area2D

func _on_Spike_body_entered(body):
	if body.name == "Slime":
		print("Slime Entered Spike")
		body.respawn();
