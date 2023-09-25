extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match Global.PlayerSelect:
		0:
			get_node("PlayerSelect").play("walkside")
			get_node("Des").text = "Matato"
		1:
			get_node("PlayerSelect").play("hidden")
			get_node("Des").text = "hidden 1"
		2:
			get_node("PlayerSelect").play("hidden")
			get_node("Des").text = "hidden 2"
		3:
			get_node("PlayerSelect").play("hidden")
			get_node("Des").text = "hidden 3"

func _on_left_pressed():
	if Global.PlayerSelect > 0:
		Global.PlayerSelect -= 1


func _on_right_pressed():
	if Global.PlayerSelect < 3:
		Global.PlayerSelect += 1


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/ui/menu.tscn")
