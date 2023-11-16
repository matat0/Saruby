extends Control

var texture_rect

func _ready():
	texture_rect = $MarginContainer2/TextureRect

func _process(_delta):
	_on_resized()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/ui/playerselect.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/ui/Options.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_resized():
	if not texture_rect:
		return
	
	var container_size = size
	var texture_size = texture_rect.size
	var aspect_ratio = texture_size.x / texture_size.y
	
	if container_size.x / container_size.y > aspect_ratio:
		texture_rect.size.x = container_size.y * aspect_ratio
		texture_rect.size.y = container_size.y
	else:
		texture_rect.size.x = container_size.x
		texture_rect.size.y = container_size.x / aspect_ratio
	
	#texture_rect.position = (container_size - texture_rect.size) / 2

func _on_texture_rect_ready():
	_on_resized()
