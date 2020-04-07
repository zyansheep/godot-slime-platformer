extends Area2D

export (String, MULTILINE) var Text = "C + ARROW\n TO DASH"
export var Type_Speed = 0.1; #time delay between character prints

onready var label = $CanvasLayer/Label

func _ready():
	label.text = Text;
	$CanvasLayer.offset = position
	$"Type Delay".wait_time = Type_Speed;
	label.visible = false;

func _on_Sign_body_entered(body):
	if body.name != "Slime": return
	if body.states[body.state] == body.heavy:
		$Sprite.frame = 1;
	if $Sprite.frame == 1: return;
	label.visible_characters = 0
	label.visible = true
	$"Type Delay".start()


func _on_Sign_body_exited(body):
	label.visible = false

func _on_Type_Delay_timeout():
	if label.visible_characters < label.text.length():
		label.visible_characters += 1;
		$"Type Delay".start();
	else:
		$"Type Delay".stop();
