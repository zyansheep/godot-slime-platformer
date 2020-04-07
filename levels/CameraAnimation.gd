extends AnimationPlayer

func _ready():
	play("Beginning")

func _on_CameraAnimation_animation_finished(anim_name):
	match anim_name:
		"Beginning": get_node("../Camera").target_node = get_node("../Slime")
