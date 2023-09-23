extends CharacterBody2D

var speed = 20

var player_chase = false
var player = null

func _ready():
	$AnimatedSprite2D.play("idle")

