extends Node
var enemy = null
var boss_slain = false
var player_current_attack = false
var enemy_position : Vector2 = Vector2.ZERO
var score = 0
var gamer = null
func _on_enemy_defeated(loot):
	# Handle the enemy_defeated signal
	var score_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/score
	score += loot  # Update the score
	score_label.text = str(score) 
	print(score)
	

		
var characters : Array = [preload("res://Scenes/entities/player/player_character/matato.tscn"), preload("res://Scenes/entities/player/player_character/carty.tscn"), preload("res://Scenes/entities/player/player_character/butch.tscn")]
#Character Variables - mato
var PlayerSelect = 0
