extends CharacterBody2D

var target_position: Vector2
var target
var speed = 350
var pathName = ""
var bulletDamage
var impacted = false

func _ready():
	$arcane_wave.play("arcane_wave")
	$cast.play()

func _physics_process(_delta):
	
	if target_position and not impacted:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		$arcane_wave.look_at(target_position)

func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		body.health -= bulletDamage
		impacted=true
		$arcane_wave.queue_free()
		$impact.play()
		
func _on_impact_finished() -> void:
	if impacted:
		self.queue_free()
