extends Sprite

func _ready():
	$"Alpha Timeout".interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	$"Alpha Timeout".start();

func _on_Alpha_Timeout_tween_completed(object, key):
	queue_free() #Free object after it fades out
