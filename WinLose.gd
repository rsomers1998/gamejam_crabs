extends Sprite

var time = 0

func _ready():
	self.global_position = get_viewport_rect().size / 2

func _process(delta):
	time += delta
	self.scale = Vector2(1,1) * (1 + 0.1 * sin(0.5 * time))