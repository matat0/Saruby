extends TextureButton

@onready var key = $key
@onready var progress_bar = $TextureProgressBar
@onready var attack_cd = $spell2_cd
@onready var gcd_timer = $"../gcd_timer"
@onready var cast_timer = $arcane_wave_cast_time
@onready var cast_bar = $"../../cast_bar"

@export var player: CharacterBody2D

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
	cast_bar.value = cast_timer.time_left
	if !cast_timer.is_stopped():
		player.gcd = true

func _on_pressed():
	if !player.gcd:
		if player.deep_freeze_charges >0:
			player.deep_freeze_charges -= 1
			player.arcane_wave_instant_cast()
			attack_cd.stop()
			cast_timer.stop()
			
		else:
			player.casting = true
			attack_cd.start()
			cast_timer.start()
			gcd_timer.start()
			disabled = true
			set_process(true)


func _on_attack_cd_timeout():
	disabled = false
	set_process(false)
	emit_signal("attack_off_cd")
