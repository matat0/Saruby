extends CanvasLayer


@export var fade_time: float = 0.5

func _fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property($"Black Rectangle", "modulate:a", 1.0, fade_time)
	await tween.finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
