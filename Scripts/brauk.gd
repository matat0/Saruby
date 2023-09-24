extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var speed = 200 #this value is inverse to the actual speed (higher # = slower movement)
var player_chase = false
var player = null
var health = 500
var player_in_range = false

func _physics_process(delta):
	#deal_with_damage() old melee function
	
	if player_chase and health > 0:
		var direction_to_player = (player.position - position).normalized()
		if direction_to_player.x < 0:
			sprite.flip_h = false
		
		elif direction_to_player.x > 0:
			sprite.flip_h = true
		
		position += (player.position - position)/speed
		
		if direction_to_player.length() > 0.01:
			sprite.play("braukwalk")
			
	elif health <= 0:
		health = 0
		Global.boss_slain = true
		sprite.play("braukdeath")
	
	else:
		sprite.play("idle")


func _on_animated_sprite_2d_animation_finished():
	print("GZ u killed brauk")
	self.queue_free()



func enemy():
	pass

func _ready():
	pass
	

func _on_aggro_range_body_entered(body):
	player = body
	player_chase = true
	


func _on_aggro_range_body_exited(body):
	player = null
	player_chase = false


func _on_brauk_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_range = true


func _on_brauk_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false

#func deal_with_damage():    old meleee function, only keeping it for future melee attack reference
#	if player_in_range and Global.player_current_attack:
#		health = health - 20
#		print("brauk health =", health)
#		

