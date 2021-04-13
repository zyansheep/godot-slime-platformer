extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	self.text = String(Engine.get_frames_per_second());


func _on_Pause_show_fps(toggle):
	self.visible = toggle
