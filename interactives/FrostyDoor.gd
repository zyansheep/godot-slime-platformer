extends StaticBody2D

func _on_FrostyButton_pressed():
	open()

#make sure to create new shape for each door so the door's shape resources aren't shared
func _ready():
	close();

var is_open = false;
func open():
	if is_open: return;
	is_open = true;
	$AnimationPlayer.play("Open")
	
func close():
	if !is_open: return;
	is_open = false;
	$AnimationPlayer.play_backwards("Open")
	
	
