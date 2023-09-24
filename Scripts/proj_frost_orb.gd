extends CharacterBody2D

var target_position: Vector2
var target
var speed = 200
var pathName = ""
var bulletDamage
var pathSpawnerNode


	
func _physics_process(_delta):
	
	if target_position:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	
	


func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		body.health -= bulletDamage
		queue_free()
