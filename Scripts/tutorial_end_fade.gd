extends Area2D

@export var locked_velocity: Vector2 = Vector2(1,0)  #used to lock player movement in that direction

func locked_movement(): #just a flag to let the player script know to lock movement
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area: Area2D) -> void:
	print("cutscene area entered and found: " + str(area))
	if area.get_parent().has_method("player"):
		print("setting " + str(area.get_parent()) + "'s velocity to: " + str(locked_velocity))
		var player = area.get_parent()
		player.locked_movement = true
		player.locked_velocity = locked_velocity
		
	
	ScreenFade.transition()
	
	await ScreenFade.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
