extends Node

const DASH_SPEED = 200
const DASH_LENGTH_SQUARED = 2000;
const NUM_DASH = 1;

var block_movement = false
var block_physics = false
var block_animation = false
var func_name = "Dash"

var dash_start_pos = Vector2(0,0);
var dash_num_left = 0;
var dash_active = false;
var dash_dir = Vector2.ZERO;
var next_dash_registered = false;

func can_trigger():
	if next_dash_registered and dash_num_left > 0 and !dash_active:
		return true
	return false

func sign_flip_h(object):
	if(object.get_node("Sprite").flip_h): return 1;
	else: return -1;

func trigger(object):
	next_dash_registered = false;
	dash_num_left -= 1;
	dash_start_pos = object.position
	
	dash_dir = object.input_vector.normalized();
	if dash_dir.x == 0 && dash_dir.y == 0:
		dash_dir.x = sign_flip_h(object);
	
	block_movement = true;
	block_animation = true;
	block_physics = true;
	dash_active = true
	#Ghost effect
	object.start_ghost_timer();
	#Camera shake effect
	object.camera.shake(0.2, 2, 2)
	$"Dash SFX".play();

func halt(_object):
	block_movement = false;
	block_animation = false;
	block_physics = false;
	dash_active = false

func process(object):
	if Input.is_action_just_pressed("game_dash") && dash_num_left > 0:
		next_dash_registered = true;
	if object.grounded:
		dash_num_left = NUM_DASH;
	
	if can_trigger():
		trigger(object);

	if dash_active:
		if dash_start_pos.distance_squared_to(object.position) >= DASH_LENGTH_SQUARED \
		 || ((object.is_on_ceiling() || object.is_on_floor()) && dash_dir.y != 0) \
		 || (object.is_on_wall() && dash_dir.x != 0): # if collided during slide, stop dash
			halt(object);
			pass;
		object.velocity = dash_dir * DASH_SPEED;
		
