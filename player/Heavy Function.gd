extends Node

const HEAVY_WEIGHT = 20;

var heavy_active = false;

var block_animation = true;
var block_physics = true;
var block_movement = true;
var func_name = "Heavy"

func halt(_object):
	heavy_active = false;
	#object.get_node("Sprite/AnimationPlayer").play("Transform Heavy Reverse")

var was_grounded = false;

func process(object):
	if !heavy_active:
		heavy_active = true;
		#object.get_node("Sprite/AnimationPlayer").play("Transform Heavy")
		was_grounded = object.grounded;
	
	if !was_grounded && object.grounded:
		object.camera.shake(0.2, 15, 6)
	
	was_grounded = object.grounded
	if not object.grounded:
		object.velocity.y += HEAVY_WEIGHT
		object.velocity.x = 0;

