extends CharacterBody2D

var speed = 200

var input_direction: get = _get_input_direction
var sprite_direction = "right": get = _get_sprite_direction	
var score = 0 #unimplemented

var enemy_in_range = false #is the enemy close enough to melee attack the player?
var enemy_attack_ready = true #is the enemy's melee attack OFF cooldown?
var health = 100
var player_alive = true
var health_bar = preload("res://Scenes/entities/boss_health.tscn")

var Bullet = preload("res://Scenes/entities/player/player_character/player_projectiles/proj_frost_orb.tscn") 
var Phoenix = preload("res://Scenes/entities/player/player_character/player_projectiles/phoenix.tscn")
var Arcane = preload("res://Scenes/entities/player/player_character/player_projectiles/arcane_wave.tscn")
var bulletDamage = 200
#var pathName
#var currTarget
#var curr
var attack_cd = false #is frost orb on cooldown
var spell1_cd = false #is pheonix blast on cooldown
var spell2_cd = false #is arcane wave on cooldown
var spell3_cd = false #is time warp (cast) on cooldown
var tw_buff_duration = false #is time warp buff active
var damage_modifier = 1 #damage multiplier to use for buffs like latent arcana

@onready var attack_cd_timer = $Camera2D/combat_ui_real/HBoxContainer/attackbutton/attack_cd 
@onready var spell1_cd_timer = $Camera2D/combat_ui_real/HBoxContainer/spell1/spell1_cd
@onready var spell2_cd_timer = $Camera2D/combat_ui_real/HBoxContainer/spell2/spell2_cd
@onready var spell3_cd_timer = $Camera2D/combat_ui_real/HBoxContainer/spell3/spell3_cd

@onready var sprite = $AnimatedSprite2D
@onready var tw_duration = $Camera2D/combat_ui_real/HBoxContainer/spell3/tw_duration

#set get for latent arcana charges
var latent_arcana_charges:
	set(new_latent_arcana_charges): 
		if new_latent_arcana_charges >= 0 and new_latent_arcana_charges <= 4: #only update if between 0 and 4
			latent_arcana_charges = new_latent_arcana_charges
			print("set new latent_arcana_charges")
			$Camera2D/combat_ui_real/VBoxContainer/latent_arcana_charges_label.text = "latent_arcana_charges: " + str(latent_arcana_charges)
			
	get:
		return latent_arcana_charges
		

func _ready(): 
	"""
	Called after player node and all of its children are added to the tree; after everything else like timers are created
	
	"""
	
	#creates health bar instance and adds it to player body
	var instanced_health_bar = health_bar.instantiate()
	add_child(instanced_health_bar)
	
	latent_arcana_charges = 0 #init buff charges
	"""
	
	"""
	#uses the current tilemap to calculate camera boundaries, should work on any tilemap
	#$Camera2D/combat_ui_real/HBoxContainer/attackbutton/attack_cd.connect
	
	#var tilemap_rect = get_parent().get_child(0).get_node("TileMap").get_used_rect()
	#var tilemap_cell_size = get_parent().get_child(0).get_node("TileMap").tile_set.tile_size
	#$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	#$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	#$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	#$Camera2D.limit_top = tilemap_rect.position.x * tilemap_cell_size.y
	#$tw_clock.play("empty")
	#get_parent().get_child(2).connect("award_loot", self, _on_brauk_death)
	

func _physics_process(_delta):
	"""
	Controls all movement for the player, called every frame,
	
	Parameters:
		_delta (float): time between frames, currently unused
	
	"""
	
	velocity = input_direction * speed  
	
	if Global.boss_slain == false: #only allows attack functions if boss is alive
		attack()
	
	move_and_slide() #moves the player based off of the velocity
	
	if health <= 0:   #kills the player if health reaches 0
		player_alive = false 
		health = 0    #health = 0 in case damage makes player health <0
		print("rip bozo")
		self.queue_free() #deletes the player node, should be replaced with death screen or similar
	set_animation("walk") #starts the first animation
	
	if velocity == Vector2.ZERO: #if the player stops moving
		sprite.stop()            #stop playing the sprite's animation
	
	enemy_attack() #process enemy attacks
	

func set_animation(animation): 
	"""
	Sets the player's animation, not fully implemented,
	only has one walk animation that is flipped when going left
	
	Parameters:
		animation(str): what animation to play
	"""
	var direction = "side" 
	if sprite_direction in ["left", "right", "up" , "down"]: #makes sure direction is in the list of valid directions
		sprite.play(animation + direction)                   #only animation is "walkside"
		sprite.flip_h = (sprite_direction == "left")         #flips when going left
		
	else: 
		pass

func _get_input_direction(): 
	""" 
	Takes player input and creates a 2d vector
	
	Returns:
		input_direction(2d Vector): input direction
	"""
	var x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right")) #horizontal move
	var y = -int(Input.is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down"))    #vertical move
	input_direction = Vector2(x,y).normalized() #normalizes direction so going diagonal is same speed as going straight
	return input_direction
	
func _get_sprite_direction():
	""" 
	Determines which direction of sprite movement to play based off of the input vector
	Getter function for var sprite_direction (str)
	Currently, only side walk cycle is animated so this isn't fully used, 
	the side sprite is just flipped horizontally
	
	Returns:
		sprite_direction(str): what direction sprite should be playing
	"""
	match input_direction:  #what direction is the vector currently
		Vector2.LEFT:
			sprite_direction = "left"
		Vector2.RIGHT:
			sprite_direction = "right"
		Vector2.UP:
			sprite_direction = "up"
		Vector2.DOWN:
			sprite_direction = "down"
	return sprite_direction

func player(): #used to signal to other hitboxes that this is a player using hasMethod
	pass

func _on_matato_hitbox_body_entered(body):
	""" 
	Triggered whenever another body enters the player's hitbox
	Parameters:
		body(node): whatever entered the hitbox
	"""
	
	if body.has_method("enemy"): #if the body that entered is an enemy, they are in range to hit player
		enemy_in_range = true


func _on_matato_hitbox_body_exited(body):
	""" 
	Triggered whenever another body exits the player's hitbox
	Parameters:
		body(node): whatever exited the hitbox
	"""
	if body.has_method("enemy"): #if the body that exits is an enemy, they aren't in range anymore
		enemy_in_range = false

func enemy_attack():
	""" 
	Ran every frame by _physics_process
	Handles logic for enemy attacks
	Currently, any enemy attack will trigger I-frames for the player because there is only one enemy
	"""
	if enemy_in_range and enemy_attack_ready == true: #if the enemy is in range and their attack is OFF cooldown
		health = health - 20  
		enemy_attack_ready = false
		$damage_taken_cooldown.start()  #starts timer for next enemy attack
		print(health)

func _on_damage_taken_cooldown_timeout():
	"""  
	Triggered by damage_taken_cooldown timer ending
	
	"""
	enemy_attack_ready = true

func attack():
	"""  
	Handles the logic surrounding the basic attack (frost orb) for the player
	
	"""
	var enemy = Global.enemy #declares the singular enemy as the boss
	if Input.is_action_just_pressed("attack") and Global.enemy: #if the player attacks and there is an enemy to attack
		#Global.player_current_attack = true
		if attack_cd == false and enemy: #if the attack is off cooldown and there is an enemy (redundant enemy check) 
			#put the attack on cooldown and start the timer
			attack_cd = true
			attack_cd_timer.start()
			print("frost orb pressed")
			
			#predetermine the damage and target for the bullet
			var tempBullet = Bullet.instantiate()
			tempBullet.target_position = enemy.global_position #target is where enemy is
			tempBullet.bulletDamage = bulletDamage * damage_modifier #determine bullet damage
			
			#actually places the bullet into the world and fires it
			get_node("BulletContainer").add_child(tempBullet)
			tempBullet.global_position = $Aim.global_position
		elif attack_cd:
			print("You can't attack yet, wait a sec")

func _on_attack_cd_timeout():
	"""  
	Triggered by all timers, putting the basic attack off GCD, will probably be changed later
	"""
	attack_cd = false
	print("attack off cd")

func _on_spell_1_pressed():
	"""  
	Handles pheonix logic, triggered by pressing spell 1 button (w)
	Functionally the same as normal attack right now
	"""
	var enemy = Global.enemy  #declare target enemy
	if spell1_cd == false and enemy:  #if the spell is off cooldown and there is an enemy
		spell1_cd = true
		spell1_cd_timer.start()
		print("phoenix pressed")
		
		var tempBullet = Phoenix.instantiate()
		tempBullet.target_position = enemy.global_position
		tempBullet.bulletDamage = bulletDamage * damage_modifier
		
		get_node("BulletContainer").add_child(tempBullet)
		tempBullet.global_position = $Aim.global_position
	elif attack_cd:
		print("You can't attack yet, wait a sec")

func _on_spell_2_pressed():
	"""    
	Handles arcane wave logic, triggered by pressing spell 2 button (e)
	Functionally the same as normal attack right now
	
	"""
	var enemy = Global.enemy
	if spell2_cd == false and enemy:
		spell2_cd = true
		spell2_cd_timer.start()
		print("arcane_wave pressed")
		
		var tempBullet = Arcane.instantiate()
		tempBullet.target_position = enemy.global_position
		tempBullet.bulletDamage = bulletDamage * damage_modifier
		
		get_node("BulletContainer").add_child(tempBullet)
		tempBullet.global_position = $Aim.global_position
	elif attack_cd:
		print("You can't attack yet, wait a sec")

func _on_spell_3_pressed():
	"""    
	Handles time warp logic, triggered by pressing spell 3 button (R)
	Linked to an extra timer node that dictates how long the buff lasts
	
	"""
	#makes sure there is an enemy and targets it, kind of unnecessary
	var enemy = Global.enemy 
	
	if spell3_cd == false and enemy:
		spell3_cd = true
		spell3_cd_timer.start()
		print("time warp pressed")
		
		$tw_clock.play("default")  #time warp sound
		tw_duration.start()        #start buff duration timer
		speed = 250  #increases player speed, default is 200, eventually speed 
					 #should be calculated by default speed added to or multiplied by modifiers
						
	elif attack_cd:
		print("Time warp not ready")


"""  
The following are all connected to timers and take spells off of cooldown
"""
func _on_spell_1_cd_timeout():
	spell1_cd = false

func _on_spell_2_cd_timeout():
	spell2_cd = false

func _on_spell_3_cd_timeout():
	spell3_cd = false

func _on_tw_duration_timeout():
	tw_buff_duration = false
	$tw_clock.play("empty")
	speed = 200       #return speed to default, should be changed in future by modifier

# node connection to scene change area2D object
# this function calls the screen_fade.tscn scene for scene transitions
func _on_area_2d_area_entered(area):
	ScreenFade.transition()
	await ScreenFade.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
