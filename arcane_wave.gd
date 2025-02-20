extends CharacterBody2D

var target_position: Vector2
var target
var speed = 350
var pathName = ""
var bulletDamage
var latent_arcana 
var debuff_timer = preload("res://Scenes/entities/enemy/enemy_buffs/debuff_1_timer.tscn")

func _ready():
	$arcane_wave.play("arcane_wave")


func _physics_process(_delta):
	
	if target_position:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		$arcane_wave.look_at(target_position)

func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		
		if latent_arcana:
			print("trying to add stacks")
			var new_timer = debuff_timer.instantiate()
			body.add_child(new_timer)
			body.vulnerability_multiplier += 1
		body.health -= bulletDamage
		self.queue_free()
