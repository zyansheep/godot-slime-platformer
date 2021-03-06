extends KinematicBody2D

const MAX_FALL_SPEED = 250
const MAX_GROUND_SPEED = 100;
const JUMP_FORCE = 150

const GRAVITY = 800
const ACCELERATION = 1000; #7 frames to start
const FRICTION = 1300 #6 frames to stop
const AIR_FRICTION = 300;

const WALL_JUMP_VELOCITY = Vector2(100, -270);

var old_velocity = Vector2.ZERO;
var velocity = Vector2.ZERO;
var grounded = false;
var on_wall = false;
var in_wall_jump = false
var no_friction_frames = 0
var no_movement_frames = 30
#var wall_stamina = 100;

var is_morphing = false;

var frames_since_jump_attempt = 0
var input_vector = Vector2.ZERO;

onready var dash = get_node("Dash Function")
onready var heavy = get_node("Heavy Function")
onready var normal = get_node("Normal Function")
#onready var magic = get_node("Magic Function")

#handle for Slime scripts to access camera functions
onready var camera = get_node("../Camera")

onready var states = {
	"Dash": dash,
	"Heavy": heavy,
	"Normal": normal
}
var state_cycle_dict = {
	"Normal": "Dash",
	"Dash": "Heavy",
	"Heavy": "Dash"
}
var cur_state

onready var anim_tree = $Sprite/AnimationTree
var playback : AnimationNodeStateMachinePlayback
var spawn_pos;
func _ready():
	spawn_pos = position;
	cur_state = states[Data.Slime.State]
	playback = $Sprite/AnimationTree.get("parameters/animations/playback")
	playback.start(Data.Slime.State)
	#anim_tree.active = true;

func respawn():
	position = spawn_pos
	camera.position = position
	playback.start(Data.Slime.State)
	change_state(Data.Slime.State)

func _process(_delta):
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var current_animation = playback.get_current_node()
	
	#Process current ability every frame (e.g. dash, magic, heavy)
	cur_state.process(self)
	
	#Used for pausing certain processes
	no_friction_frames -= 1
	no_movement_frames -= 1
	
	#Dev respawn point
	if Input.is_key_pressed(KEY_S):
		spawn_pos = position;
	
	if Input.is_action_just_pressed("game_next_level"):
		var next_level = get_node_or_null("../Interactive/Next Level")
		if next_level:
			position = next_level.position
	
	if not cur_state.block_movement:
		input_vector = Vector2(
			Input.get_action_strength("game_right") - Input.get_action_strength("game_left"),
			Input.get_action_strength("game_down") - Input.get_action_strength("game_up"))
		
		#Left/Right movement force
		#Movement acceleration
		if input_vector != Vector2.ZERO && no_movement_frames <= 0:
			velocity.x = clamp(velocity.x + input_vector.x * ACCELERATION * delta, -MAX_GROUND_SPEED, MAX_GROUND_SPEED)
		
		#Movement deceleration
		elif grounded: 
			var p_delta = FRICTION * delta
			if abs(velocity.x) <= p_delta: velocity.x = 0
			else: velocity.x = velocity.x + -sign(velocity.x) * p_delta
		
		#Jump force
		frames_since_jump_attempt += 1; #Allow jump registering a certain number of frames before hitting the ground
		if Input.is_action_just_pressed("game_jump"): frames_since_jump_attempt = 0;
		if grounded && (frames_since_jump_attempt <= 2):
			#print(cur_state.func_name, " vs ", Data.Slime.State, " vs ", current_animation)
			if Data.Slime.State != current_animation:
				playback.start(Data.Slime.State)
			velocity.y -= 15000 * delta
		
		#Wall Jump code
		if on_wall && !grounded && frames_since_jump_attempt <= 2:
			velocity = WALL_JUMP_VELOCITY
			velocity.x = abs(velocity.x) * -dash.sign_flip_h(self)
			$Sprite.flip_h = !$Sprite.flip_h
			in_wall_jump = true
			no_movement_frames = 15
			no_friction_frames = 30
		
	if not cur_state.block_physics:
		#Gravitational force
		if !on_wall:
			velocity.y = clamp(velocity.y + GRAVITY * delta, -1000, MAX_FALL_SPEED);
		elif no_friction_frames <= 0:
			velocity.y = clamp(velocity.y + GRAVITY * delta, -1000, 100);
		
		if !grounded && no_friction_frames <= 0:
			#velocity = velocity.move_toward(Vector2.ZERO, AIR_FRICTION * delta)
			var p_delta = AIR_FRICTION * delta
			if abs(velocity.x) <= p_delta: velocity.x = 0
			else: velocity.x = velocity.x + -sign(velocity.x) * p_delta
		
	if Input.is_action_just_pressed("game_morph"):
		playback.travel(state_cycle_dict[cur_state.func_name] + " Transform")
		
		anim_tree.set("parameters/timescale/scale", 40)
		Engine.time_scale = 0.1;
		is_morphing = true;
		$TransformAudio.play();
		
		
	if is_morphing && !Input.is_action_pressed("game_morph"):
		var animation_state = current_animation.split(" ")[0]
		#anim_tree.set("parameters/timescale/scale", 4)
		if animation_state != "Reverse":
			playback.travel(animation_state)
			change_state(animation_state)
			anim_tree.set("parameters/timescale/scale", 2)
			Engine.time_scale = 1;
		if current_animation.split(" ").size() == 1:
			is_morphing = false;
			anim_tree.set("parameters/timescale/scale", 1)
			$TransformAudio.stop();
		
		
	
	#Move Character
	old_velocity = velocity;
	velocity = move_and_slide(velocity, Vector2(0,-1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Death":
			respawn()
		
	var was_grounded = grounded;
	var was_on_wall = on_wall;
	grounded = is_on_floor();
	if grounded: in_wall_jump = false
	on_wall = is_on_wall();
	
	
	
	if not cur_state.block_animation:
		if Input.is_action_pressed("game_left"): $Sprite.flip_h = false;
		if Input.is_action_pressed("game_right"): $Sprite.flip_h = true;
		
		#Animations
		if was_grounded == false && grounded == true:
			$Particles2D.emitting = true
			if old_velocity.y > MAX_FALL_SPEED-1:
				play_state_animation("Bounce")
			elif old_velocity.y > 100:
				play_state_animation("Bounce Little")
		
		#Just went on wall this frame
		if !was_on_wall && on_wall && !grounded:
			play_state_animation("Wall")
			#velocity.y = 0
		#just left wall this frame
		elif was_on_wall && !on_wall:
			play_state_animation("Idle")

func play_sound(name):
	$MainAudio.stream = load("res://assets/" + name + ".wave")
	$MainAudio.play()

func play_state_animation(name):
	var state_playback = $Sprite/AnimationTree.get("parameters/animations/" + cur_state.func_name + "/playback")
	state_playback.travel(name)

func change_state(key : String):
	cur_state.halt(self);
	cur_state = states[key];
	Data.Slime.State = key

#GHOST EFFECT
const NUM_GHOSTS = 3 #only 3 afterimages
var ghost_times = 0;
func start_ghost_timer():
	$"Ghost Timer".paused = false;
	ghost_times = NUM_GHOSTS;
	

func _on_Ghost_Timer_timeout():
	ghost_times -= 1
	if ghost_times <= 0:
		$"Ghost Timer".paused = true;
	
	var ghost = preload("res://player/Ghost Effect.tscn").instance()
	get_parent().add_child(ghost)
	ghost.position = position
	ghost.texture = $Sprite.texture
	ghost.hframes = $Sprite.hframes
	ghost.vframes = $Sprite.vframes
	ghost.frame = $Sprite.frame
	ghost.flip_h = $Sprite.flip_h
		
