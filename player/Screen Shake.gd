extends Camera2D

#Camera2D Shaking Script from Godot Q&A

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)

var smoothing = true;
export(NodePath) var target_node_path;
var target_node : Node = null;
export var track_speed = 50;

func _ready():
	var animation = get_node_or_null("CameraAnimation")
	if animation:
		animation.play("Beginning")

# Shake with decreasing intensity while there's time remaining.
var previous_target_node_path = target_node_path;
func _process(delta):
	if target_node_path != previous_target_node_path:
		target_node = get_node(target_node_path)
	previous_target_node_path = target_node_path;
	#Camera movement
	if target_node != null:
		var move_speed = max(target_node.velocity.length(), track_speed);
		if smoothing:
			position = position.move_toward(target_node.position, delta * move_speed)
		else: position = target_node.position;
		
	
	# Only shake when there's shake time remaining.
	if _timer != 0:
		# Only shake on certain frames.
		_last_shook_timer = _last_shook_timer + delta
		# Be mathematically correct in the face of lag; usually only happens once.
		while _last_shook_timer >= _period_in_ms:
			_last_shook_timer = _last_shook_timer - _period_in_ms
			# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
			var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
			# Noise calculation logic from http://jonny.morrill.me/blog/view/14
			var new_x = rand_range(-1.0, 1.0)
			var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
			var new_y = rand_range(-1.0, 1.0)
			var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
			_previous_x = new_x
			_previous_y = new_y
			# Track how much we've moved the offset, as opposed to other effects.
			var new_offset = Vector2(x_component, y_component)
			set_offset(get_offset() - _last_offset + new_offset)
			_last_offset = new_offset
		# Reset the offset when we're done shaking.
		_timer = _timer - delta
		if _timer <= 0:
			_timer = 0
			set_offset(get_offset() - _last_offset)
		
	

# Kick off a new screenshake effect.
func shake(duration, frequency, amplitude):
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = rand_range(-1.0, 1.0)
	_previous_y = rand_range(-1.0, 1.0)
	# Reset previous offset, if any.
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)
