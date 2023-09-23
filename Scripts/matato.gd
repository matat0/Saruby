extends CharacterBody2D

const speed = 100

var input_direction: get = _get_input_direction
var sprite_direction = "right": get = _get_sprite_direction	

@onready var sprite = $AnimatedSprite2D


func _ready():
	var tilemap = get_parent().get_node("TileMap")
	if tilemap:
		var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
		var tilemap_cell_size = get_parent().get_node("TileMap").tile_set.tile_size
		$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x 
		$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
		$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y 
		$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y 


func _physics_process(delta):
	velocity = input_direction * speed
	move_and_slide()
	
	set_animation("walk")
	if velocity == Vector2.ZERO:
		sprite.stop()
		
func set_animation(animation):
	var direction = "side" 
	if sprite_direction in ["left", "right", "up" , "down"]:
		sprite.play(animation + direction)
		sprite.flip_h = (sprite_direction == "left")
		
	else: 
		sprite_direction


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

