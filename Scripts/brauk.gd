extends CharacterBody2D
var frame_velocity
var health_bar = preload("res://Scenes/entities/boss_health.tscn")
@onready var death_timer = $"boss death scene timer"
@onready var prev_position : Vector2 = Vector2.ZERO
@onready var direction : Vector2 = Vector2.ZERO
@onready var sprite = $body
@onready var animation_tree : AnimationTree = $AnimationTree
var getting_hurt = false
var speed = 75 
var player_chase = false
var player = null
var health: 
	#Setter/Getter for Brauk's Health:
	set(new_health):
		var damage_taken #used for damage numbers
		if health == null: #if health is null, initialize it
			health = new_health
		else:
			damage_taken = health - new_health
		health = new_health
		print("set new health")
		if new_health > 0 and new_health < 5000:
			_on_damage_taken()  #just sets getting_hurt to true
			player_chase = true #starts aggro if player hasn't already
			#print(player, "boss ouch")
			_on_aggro_range_body_entered(Global.gamer) #sets player as target for chase
			spawn_damage_number(damage_taken, self.global_position) #spawns damage number at brauk's position
	get:
		return health
		
		
func spawn_damage_number(amount, position):
	"""  
	Creates damage numbers
	Parameters:
		amount(int): value of damage number
		position(Vector2): 2d vector, coordinate to spawn label
	"""
	
	#preloads the damage number and sets the damage amount
	var damage_number_instance = preload("res://Scenes/entities/enemy/enemy_character/damage_number.tscn").instantiate()
	damage_number_instance.text = str(amount)
	
	
	#damage_number_instance.global_position = position
	
	#adds the damage number to brauk node
	add_child(damage_number_instance)
	


var player_in_range = false
signal enemy_defeated
var loot = 500



func _update_animation_parameters():
	"""  
	Updates animation tree based off of brauk's movement
	"""
	
	if(frame_velocity != Vector2.ZERO):  #if brauk is moving
		#blend animation in animation tree based off of velocity
		animation_tree["parameters/hurt/blend_position"] = frame_velocity 
		animation_tree["parameters/idle/blend_position"] = frame_velocity
		animation_tree["parameters/walk/blend_position"] = frame_velocity

		
	if Global.boss_slain:
		animation_tree["parameters/conditions/enemy_defeated"] = true
		

	if(getting_hurt):
		#plays hurt animation once and sets it back
		animation_tree["parameters/conditions/is_hurt"] = true 
		getting_hurt = false 
		
	else:
		animation_tree["parameters/conditions/is_hurt"] = false
		
	if(frame_velocity == Vector2.ZERO):  #if brauk isn't moving
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	

func _on_enemy_defeated():
	"""  
	Where we would put stuff that happens after you kill brauk, unimplemented
	"""
	pass
	

func _on_damage_taken():
	"""  
	Just sets getting_hurt to true for now, in the future 
	we can add mechanics like rage/energy to trigger mechanics
	"""
	getting_hurt = true
	#$aggro_range/CollisionShape2D.scale = Vector2(10,10) #scales aggro range by 10 when enemy loses/gains health

func _physics_process(delta):
	"""  
	Processes physics and damage, ran every frame
	The way enemy movement is handled is unusual, should probably be changed to be more consistent
	Parameters:
		delta(float): Time since last frame
	
	"""
	#deal_with_damage() old melee function
	
	var current_position = global_position #global_position is the position of brauk relevant to entire game scene
	frame_velocity = (current_position - prev_position) / delta #velocity of brauk's movement in the past frame
	prev_position = current_position   #update position
	#print("chase: " ,player_chase)
	
	_update_animation_parameters()
	
	if player_chase and health > 0 and player != null: #if the enemy is currently chasing an existing player
		var direction_to_player = (player.position - position).normalized() #calculate direction to player
		if direction_to_player.x < 0: #if direction is negative on x axis (to the left), dont flip sprite
			sprite.flip_h = false
		
		elif direction_to_player.x > 0: #if direction is positive on x axis (to the right),flip sprite
			sprite.flip_h = true
			
		elif direction_to_player.length() > 0.01: #if the player is not close to enemy, walk
			#sprite.play("braukwalk")
			pass
		#position += (player.position - position)/speed
		
		#get velocity and move the enemy
		velocity = direction_to_player * speed
		move_and_slide()
		
		#if getting_hurt:
		#	sprite.play("braukhurt")
			
		#	getting_hurt = false
		

	elif health <= 0 and Global.boss_slain == false: #incase the player overkills the boss
		health = 0
		Global.boss_slain = true
		death_timer.start()      #triggers timer to allow death animation to play
		print("started death timer")
		#sprite.play("braukdeath")
		
		
	
	else:
		#sprite.play("idle")
		pass


func _on_animated_sprite_2d_animation_finished():
	"""  
	Triggered after brauk's death scene
	"""
	if health == 0:
		print("GZ u killed brauk")
		
		"""
		These two lines of code below are for the unimplemented loot system
		emit_signal("enemy_defeated", loot)
		print("signal emitted, ", loot, Global.score)
		"""
		self.queue_free()



func enemy():
	"""  
	Just a flag to designate this body as an enemy to the player hitbox
	"""
	pass

func _ready():
	"""  
	Triggered when Brauk node is added to the scene and all of brauk's children are ready
	
	"""
	Global.enemy = $"." #sets itself as the global enemy
	#sprite.play("idle")
	animation_tree.active = true #activated animation tree
	health = 5000
	#instantiates and adds health bar
	var instanced_health_bar = health_bar.instantiate()
	add_child(instanced_health_bar)

func _on_aggro_range_body_entered(body):
	"""  
	Detects if player has entered aggro range hitbox, and starts chase
	Parameters:
		body(node): the body that entered the hitbox (should always be the player)
	"""
	if body.has_method("player"): #if body that entered is a player
		player = body             #target player
		player_chase = true       #start chase
		print(player, body, "aggro range entered", player_chase)


#func _on_aggro_range_body_exited(body):
#	player = null
#	player_chase = false


func _on_brauk_hitbox_body_entered(body):
	"""  
	Triggers if the player is close enough to melee attack
	Parameters:
		body(node): the body that entered the hitbox (should always be the player)
	"""
	if body.has_method("player"):
		player_in_range = true


func _on_brauk_hitbox_body_exited(body):
	"""  
	Triggers if the player is no longer enough to melee attack
	Parameters:
		body(node): the body that left the hitbox (should always be the player)
	"""
	if body.has_method("player"):
		player_in_range = false

#func deal_with_damage():    old meleee function, only keeping it for future melee attack reference
#	if player_in_range and Global.player_current_attack:
#		health = health - 20
#		print("brauk health =", health)
#		



func _on_boss_death_scene_timer_timeout():
	"""  
	Triggers once the timer node for the death animation finishes
	"""
	print("death scene timer done")
	queue_free() #deletes brauk
	Global.enemy = null 
