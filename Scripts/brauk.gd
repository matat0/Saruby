extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var speed = 200 #this value is inverse to the actual speed (higher # = slower movement)
var player_chase = false
var player = null
var health = 500
var player_in_range = false
 
func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		

func enemy():
	pass

func _ready():
	sprite.play("idle")


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

func deal_damage():
	pass
		
