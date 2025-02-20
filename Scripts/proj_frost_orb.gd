extends CharacterBody2D

var target_position: Vector2
var target
var speed = 350
var pathName = ""
var bulletDamage
#var pathSpawnerNode

func _ready():
	$FrostOrb.play("frost_orb")
	var deep_freeze_proc = randi_range(1,4)
	if deep_freeze_proc == 4:
		get_parent().get_parent().deep_freeze_charges += 1
		
	
func _physics_process(_delta):
	
	if target_position:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		body.health -= bulletDamage * body.vulnerability_multiplier
		$FrostOrb.play("orb_impact")

func _on_frost_orb_animation_finished():
	self.queue_free()
