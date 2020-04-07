extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var current_level = null;
func _ready():
	current_level = get_child(get_child_count() - 1); #Get first child
	#current_level.initialize($Slime, $Camera2D)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		

var follow_player = false;
func _process(event):
	if follow_player:
		$Camera2D.target = $Slime.position;

func next_level(level_resource):
	call_deferred("next_level_deferred", level_resource)


func next_level_deferred(level_resource):
	current_level.free();
	current_level = level_resource.instance();
	add_child(current_level)
	get_tree().set_current_scene(current_level);
	#current_level.initialize(get_node("Slime"));
	


func _on_AnimationPlayer_animation_finished(anim_name):
	follow_player = true
