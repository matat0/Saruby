extends TextureButton

@onready var key = $key
@onready var progress_bar = $TextureProgressBar
@onready var attack_cd = $spell3_cd
@onready var gcd_timer = $"../gcd_timer"

signal attack_off_cd

var change_key = "":
	set(value):
		change_key = value
		key.text = value
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
func _ready():
	progress_bar.max_value = attack_cd.wait_time
	set_process(false)
	
func _process(_delta):
	progress_bar.value = attack_cd.time_left

func _on_pressed():
	if gcd_timer.is_stopped():
		print("button R clicked")
		attack_cd.start()
		gcd_timer.start()
		disabled = true
		set_process(true)


func _on_attack_cd_timeout():
	disabled = false
	set_process(false)
	emit_signal("attack_off_cd")
