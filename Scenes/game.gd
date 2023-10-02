extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready(): 
	var current_player = Global.characters[Global.PlayerSelect]
	var gamer = current_player.instantiate()
	add_child(gamer)
	gamer.global_position = Vector2(600,700)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
