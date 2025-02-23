extends TextureButton

@onready var key = $key
@onready var progress_bar = $TextureProgressBar
#@onready var attack_cd = $attack_cd
@onready var gcd_timer = $"../gcd_timer"
@export var player : CharacterBody2D

var change_key = "":
	set(value):
		change_key = value
		key.text = value
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()

func _ready():
	#progress_bar.max_value = attack_cd.wait_time
	progress_bar.max_value = gcd_timer.wait_time
	
	

func _process(_delta):
	if !gcd_timer.is_stopped():
		print(gcd_timer.time_left)
	#print(attack_cd.time_left)

	#progress_bar.value = attack_cd.time_left
	progress_bar.value = gcd_timer.time_left


func _on_pressed():
	
	print("button Q clicked")
	"""
	if !player.gcd:  #and !player.attack_cd
		if gcd_timer.is_stopped():
			#attack_cd.start()
			gcd_timer.start()
			disabled = true
			set_process(true)
	"""

"""
func _on_attack_cd_timeout():
	
	disabled = false
	set_process(false)
	emit_signal("attack_off_cd")
"""


func _on_gcd_timer_timeout():
	pass
