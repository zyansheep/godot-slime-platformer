extends Node

const HEAVY_WEIGHT = 25;

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
	
	if object.old_velocity.y >= object.MAX_FALL_SPEED && object.grounded:
		var val = clamp(range_lerp(object.old_velocity.y, 250,700, 0,100), 0,100)
		object.camera.shake(0.2, range_lerp(val, 0,100,0,15), range_lerp(val, 0,100,0,6))
		$"Heavy SFX".volume_db = range_lerp(val, 0,100,-30,0);
		$"Heavy SFX".play()
		print(val)
	
	was_grounded = object.grounded
	if not object.grounded:
		object.velocity.y += HEAVY_WEIGHT
		object.velocity.x = 0;

