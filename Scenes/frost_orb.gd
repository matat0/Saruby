extends Area2D

var movement_vector := Vector2.ZERO
@export var speed := 100

func _ready():
	# direction = (Global.enemy.position - global_position.normalized())
	pass
func _physics_process(delta):
	#position += (Global.enemy.position - position)/speed



