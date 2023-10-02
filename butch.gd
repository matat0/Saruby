extends CharacterBody2D

const speed = 200

var input_direction: get = _get_input_direction
var sprite_direction = "right": get = _get_sprite_direction	
var score = 0
var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var health_bar = preload("res://Scenes/entities/boss_health.tscn")

var bulletDamage = 200
var pathName
var currTarget
var curr
var attack_cd = false
var damage_modifier = 1
@onready var attack_cd_timer = $Camera2D/combat_ui_real/HBoxContainer/attackbutton/attack_cd
@onready var sprite = $AnimatedSprite2D


func _ready(): #uses the current tilemap to calculate camera boundaries, should work on any tilemap
	var instanced_health_bar = health_bar.instantiate()
	add_child(instanced_health_bar)
	var tilemap_rect = get_parent().get_child(0).get_node("TileMap").get_used_rect()
	var tilemap_cell_size = get_parent().get_child(0).get_node("TileMap").tile_set.tile_size
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	$Camera2D.limit_top = tilemap_rect.position.x * tilemap_cell_size.y
	#get_parent().get_child(2).connect("award_loot", self, _on_brauk_death)
	

func _physics_process(_delta):
	velocity = input_direction * speed
	move_and_slide()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("rip bozo")
		self.queue_free() #replace with death screen or downed or something
	set_animation("walk")
	if velocity == Vector2.ZERO:
		sprite.stop()
	enemy_attack()

func set_animation(animation):
	var direction = "side" 
	if sprite_direction in ["left", "right", "up" , "down"]:
		sprite.play(animation + direction)
		sprite.flip_h = (sprite_direction == "right")
		
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

func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$damage_taken_cooldown.start()
		print(health)
