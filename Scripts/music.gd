extends Node

@onready var menu_music: AudioStreamPlayer = $"menu music"
@onready var player_select: AudioStreamPlayer = $player_select
@onready var brauk: AudioStreamPlayer = $brauk


func play_menu_music():
	if player_select.is_playing(): 
		player_select.stop()
	if brauk.is_playing():
		brauk.stop()
	if not menu_music.is_playing():
		menu_music.play()

func play_player_select_music():
	if menu_music.is_playing():
		menu_music.stop()
	if brauk.is_playing():
		brauk.stop()
	player_select.play()
	
func play_brauk_music():
	if menu_music.is_playing():
		menu_music.stop()
	if player_select.is_playing(): 
		player_select.stop()
	brauk.play()
