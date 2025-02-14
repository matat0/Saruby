extends Camera2D

var shake_speed = 0.2
var shake_amount = 10
var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta * shake_speed
	var x_offset = sin(time_elapsed) * shake_amount
	var y_offset = cos(time_elapsed * 1.3) * shake_amount
	position += Vector2(x_offset, y_offset) * delta
