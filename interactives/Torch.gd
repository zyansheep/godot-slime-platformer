extends Node2D

#export var(Bool) flip;
var flip = false;
func _ready():
	if flip:
		Sprite.flip_h = flip;
		Particles2D.position.x = 4
