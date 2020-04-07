extends StaticBody2D

func _on_FrostyButton_pressed():
	open()

#make sure to create new shape for each door so the door's shape resources aren't shared
var rect = RectangleShape2D.new();
func _ready():
	rect.extents = Vector2(16,32);
	$CollisionShape2D.shape = rect;

var is_open = false;
func open():
	if is_open: return;
	is_open = true;
	$Sprite/AnimationPlayer.play("Open")
	$CollisionShape2D.position.y = -24
	$CollisionShape2D.shape.extents.y = 8
	
func close():
	if !is_open: return;
	is_open = false;
	$Sprite/AnimationPlayer.play_backwards("Open")
	$CollisionShape2D.position.y = 0
	$CollisionShape2D.shape.extents.y = 32
	
	
