extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().health = 5000
	self.max_value = get_parent().health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.value = get_parent().health
