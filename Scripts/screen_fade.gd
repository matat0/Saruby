extends CanvasLayer

# signal that is emitted from this script
# this signal will be listened to by all characters that call this script
signal on_transition_finished

# variables for ColorRect (black screen overlay) and AnimationPlayer (animation timeline, keyframes)
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer


func _ready():
	
	# ColorRect always starts invisible to not interfere with gameplay interactivity
	color_rect.visible = false
	
	# call custom function for actions that happen when the fade animations finish
	animation_player.animation_finished.connect(_on_animation_finished)
	

# custom function for actions that happen when the fade animations finish
func _on_animation_finished(animation_name):
	
	# after screen finishes fading to black, emit transition finished signal
	if animation_name == "fade_to_black":
		on_transition_finished.emit()
		
		# starts fade_to_normal after fade_to_black is finished
		animation_player.play("fade_to_normal")
		
	# after fading to normal, make ColorRect invisible
	elif animation_name == "fade_to_normal":
		color_rect.visible = false

# function that makes ColorRect visible and plays animations
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
