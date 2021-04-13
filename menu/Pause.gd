extends Control

signal show_fps(toggle);

var pause_state;

func _ready():
	visible = false;

func _input(event):
	if event.is_action_pressed("game_pause"):
		pause_state = not get_tree().paused
		get_tree().paused = pause_state
		visible = pause_state


func _on_CheckButton_toggled(button_pressed):
	emit_signal("show_fps", button_pressed)
