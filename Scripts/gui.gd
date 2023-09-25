extends CanvasLayer



@onready var score_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/score  # Reference to the Label node

func _ready():
	var enemy = get_node("../brauk")
	if enemy:
		print("connected")
		enemy.connect("enemy_defeated", enemy._on_enemy_defeated)



func _on_enemy_defeated(loot: int):
	# Handle the enemy_defeated signal
	Global.score += loot  # Update the score
	score_label.text = str(Global.score) 
	print("attempted to update")
