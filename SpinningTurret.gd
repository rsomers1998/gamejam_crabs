extends Turret

var max_speed = 0.02
var speed = 0

func _process(_delta):
	speed = max(0, speed - 0.0001)
	self.rotation += speed
	
func turret_rotate(_target):
	speed = min(max_speed, speed + 0.0002)