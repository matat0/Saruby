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
	set(new_health):
		var damage_taken
		if health == null:
			health = new_health
		else:
			damage_taken = health - new_health
		health = new_health
		print("set new health")
		if new_health > 0 and new_health < 5000:
			_on_damage_taken()
			spawn_damage_number(damage_taken, self.position)
	get:
		return health
		
		
func spawn_damage_number(amount, position):
	var damage_number_instance = preload("res://Scenes/entities/enemy/enemy_character/damage_number.tscn").instantiate()
	damage_number_instance.text = str(amount)
	damage_number_instance.global_position = position
	add_child(damage_number_instance)
var player_in_range = false
signal enemy_defeated
var loot = 500



func _update_animation_parameters():
	if(frame_velocity != Vector2.ZERO):
		animation_tree["parameters/hurt/blend_position"] = frame_velocity
		animation_tree["parameters/idle/blend_position"] = frame_velocity
		animation_tree["parameters/walk/blend_position"] = frame_velocity

		
	if Global.boss_slain:
		animation_tree["parameters/conditions/enemy_defeated"] = true
		

	if(getting_hurt):
		animation_tree["parameters/conditions/is_hurt"] = true
		getting_hurt = false
		
	else:
		animation_tree["parameters/conditions/is_hurt"] = false
		
	if(frame_velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	

func _on_enemy_defeated():
	pass
	

func _on_damage_taken():
	getting_hurt = true
	$aggro_range/CollisionShape2D.scale = Vector2(10,10) #scales aggro range by 10 when enemy loses/gains health
func _physics_process(delta):
	#deal_with_damage() old melee function
	var current_position = global_position
	frame_velocity = (current_position - prev_position) / delta
	prev_position = current_position

	_update_animation_parameters()
	if player_chase and health > 0:
		var direction_to_player = (player.position - position).normalized()
		if direction_to_player.x < 0:
			sprite.flip_h = false
		
		elif direction_to_player.x > 0:
			sprite.flip_h = true
			
		elif direction_to_player.length() > 0.01:
			#sprite.play("braukwalk")
			pass
		#position += (player.position - position)/speed
		velocity = direction_to_player * speed
		print(direction_to_player)
		move_and_slide()
		#if getting_hurt:
		#	sprite.play("braukhurt")
			
		#	getting_hurt = false
		

	elif health <= 0 and Global.boss_slain == false:
		health = 0
		Global.boss_slain = true
		death_timer.start()
		print("started death timer")
		#sprite.play("braukdeath")
		
		
	
	else:
		#sprite.play("idle")
		pass


func _on_animated_sprite_2d_animation_finished():
	if health == 0:
		print("GZ u killed brauk")
		emit_signal("enemy_defeated", loot)
		print("signal emitted, ", loot, Global.score)
		self.queue_free()



func enemy():
	pass

func _ready():
	Global.enemy = $"."
	#sprite.play("idle")
	animation_tree.active = true
	health = 5000
	var instanced_health_bar = health_bar.instantiate()
	add_child(instanced_health_bar)

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



func _on_boss_death_scene_timer_timeout():
	print("death scene timer done")
	queue_free()
	Global.enemy = null
