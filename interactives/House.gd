extends StaticBody2D

var is_inside = true;
func _ready():
	if is_inside:
		$Sprite/AnimationPlayer.play("Movement Inner")
	else:
		$Sprite/AnimationPlayer.play("Movement Outer")

func _on_Area_body_entered(body):
	if is_inside: return
	if body.name == "Slime":
		is_inside = true;
		$Sprite/AnimationPlayer.play("Transition");
		


func _on_Area_body_exited(_body):
	is_inside = false;
	$Sprite/AnimationPlayer.play_backwards("Transition")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Transition" && is_inside:
		$Sprite/AnimationPlayer.play("Movement Inner")
	else:
		$Sprite/AnimationPlayer.play("Movement Outer")
	
