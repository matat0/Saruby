extends CharacterBody2D

var target_position: Vector2
var target
var speed = 350
var pathName = ""
var bulletDamage

func _ready():
	$phoenix.play("phoenix")


func _physics_process(_delta):
	
	if target_position:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		$phoenix.look_at(target_position)

func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		body.health -= bulletDamage
		self.queue_free()
