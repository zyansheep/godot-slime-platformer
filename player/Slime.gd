extends KinematicBody2D

func _ready():
	pass

const MAX_FALL_SPEED = 200
const MAX_GROUND_SPEED = 100;
const JUMP_FORCE = 150

const GRAVITY = 600
const ACCELERATION = 1000; #7 frames to start
const FRICTION = 1300 #6 frames to stop
const AIR_FRICTION = 0;

var velocity = Vector2.ZERO;
var grounded = false;
var input_vector = Vector2.ZERO;


onready var dash = get_node("Dash Function")
onready var heavy = get_node("Heavy Function")
#onready var magic = get_node("Magic Function")
var state = 0
onready var states = [dash, heavy]

onready var console = get_tree().get_root().get_node("Game").get_node("MenuLayer").get_node("Console")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Process current ability every frame (e.g. dash, magic, heavy)
	states[state].process(self)
		
	if not states[state].block_movement:
		input_vector = Vector2(
			Input.get_action_strength("game_right") - Input.get_action_strength("game_left"),
			Input.get_action_strength("game_down") - Input.get_action_strength("game_up"))
		
		#Left/Right movement force
		#Movement acceleration
		if input_vector != Vector2.ZERO:
			velocity.x = clamp(velocity.x + input_vector.x * ACCELERATION * delta, -MAX_GROUND_SPEED, MAX_GROUND_SPEED)
		#Movement deceleration
		else: 
			var p_delta = FRICTION * delta
			if abs(velocity.x) <= p_delta: velocity.x = 0
			else: velocity.x = velocity.x + -sign(velocity.x) * p_delta
		
		#Jump force
		if grounded && Input.is_action_just_pressed("game_jump"):
			velocity.y -= 15000 * delta
		
	if not states[state].block_physics:
		#Gravitational force
		velocity.y = clamp(velocity.y + GRAVITY * delta, -1000, MAX_FALL_SPEED);
		
		if !grounded:
			var newvel = velocity.move_toward(Vector2.ZERO, AIR_FRICTION * delta);
			velocity.x = newvel.x;
	
	if Input.is_action_just_pressed("game_morph"):
		Engine.time_scale = 0.1;
		change_state((state+1)%states.size())
		$Sprite/AnimationPlayer.playback_speed = 20
	if Input.is_action_just_released("game_morph"):
		$Sprite/AnimationPlayer.playback_speed = 1
		"""if Input.is_key_pressed(KEY_1):
			change_state(0)
		if Input.is_key_pressed(KEY_2):
			change_state(1)"""
		Engine.time_scale = 1;
	
	#Move Character
	var old_velocity = velocity;
	velocity = move_and_slide(velocity, Vector2(0,-1))
	var was_grounded = grounded;
	grounded = is_on_floor();
	
	if not states[state].block_animation:
		if Input.is_action_pressed("game_left"): $Sprite.flip_h = false;
		if Input.is_action_pressed("game_right"): $Sprite.flip_h = true;
		
		#Animations
		if was_grounded == false && grounded == true:
			if old_velocity.y > MAX_FALL_SPEED-1:
				$Sprite/AnimationPlayer.play("Bounce")
				$Sprite.frame = 0
			elif old_velocity.y > 100:
				$Sprite/AnimationPlayer.play("Little Bounce")
				$Sprite.frame = 0
	

func change_state(num):
	states[state].halt(self);
	state = num;

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
		
