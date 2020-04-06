extends StaticBody2D

var is_inside = false;
func _ready():
	$Sprite/AnimationPlayer.play("Movement Outer")

func _on_Area_body_entered(body):
	if body.name == "Slime":
		is_inside = true;
		$Sprite/AnimationPlayer.play("Transition");
		


func _on_Area_body_exited(body):
	is_inside = false;
	$Sprite/AnimationPlayer.play_backwards("Transition")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Transition" && is_inside:
		$Sprite/AnimationPlayer.play("Movement Inner")
	else:
		$Sprite/AnimationPlayer.play("Movement Outer")
	
