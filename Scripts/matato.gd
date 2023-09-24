extends CharacterBody2D

const speed = 200

var input_direction: get = _get_input_direction
var sprite_direction = "right": get = _get_sprite_direction	

var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false

@onready var sprite = $AnimatedSprite2D

func _ready(): #uses the current tilemap to calculate camera boundaries, should work on any tilemap
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_node("TileMap").tile_set.tile_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	$Camera2D.limit_top = tilemap_rect.position.x * tilemap_cell_size.y
	
	

func _physics_process(_delta):
	velocity = input_direction * speed
	move_and_slide()
	enemy_attack()
	if health <= 0:
		player_alive = false
		health = 0
		print("rip bozo")
		self.queue_free() #replace with death screen or downed or something
	attack()
	set_animation("walk")
	if velocity == Vector2.ZERO:
		sprite.stop()
		
func set_animation(animation):
	var direction = "side" 
	if sprite_direction in ["left", "right", "up" , "down"]:
		sprite.play(animation + direction)
		sprite.flip_h = (sprite_direction == "left")
		
	else: 
		pass

func _get_input_direction():
	var x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	var y = -int(Input.is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down"))
	input_direction = Vector2(x,y).normalized()
	return input_direction
	
func _get_sprite_direction():
	match input_direction:
		Vector2.LEFT:
			sprite_direction = "left"
		Vector2.RIGHT:
			sprite_direction = "right"
		Vector2.UP:
			sprite_direction = "up"
		Vector2.DOWN:
			sprite_direction = "down"
	return sprite_direction

func player():
	pass

func _on_matato_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true


func _on_matato_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range = false

func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$damage_taken_cooldown.start()
		print(health)



func _on_damage_taken_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_ip = true
		print("attack button pressed")
	
	

	





func _on_attack_cd_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false

