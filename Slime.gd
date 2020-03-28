extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var in_air = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("game_jump") && !in_air:
		move_and_slide(Vector2(0,-1000));
		in_air = true
	
	if Input.is_action_pressed("ui_left"):
		move_and_slide(Vector2(-20,0));
	
	if Input.is_action_pressed("ui_right"):
		move_and_slide(Vector2(20,0));
	
		



func _on_Slime_body_entered(body):
	$AnimatedSprite.frame = 1;
	$Tween.interpolate_callback(self, 0.5, "reset_frame")
	$Tween.start()
	in_air = false;

func reset_frame():
	$AnimatedSprite.frame = 0;
