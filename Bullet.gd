extends Area2D

var speed = 250
var damage

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP

func set_damage(dam):
	damage = dam

func _process(delta):
	var movement = Vector2(sin(self.rotation), -cos(self.rotation)) * delta * speed
	self.translate(movement)

	if get_overlapping_bodies().size() > 0:
		for node in get_overlapping_bodies():
			if node.is_in_group('crabs'):
				node.damage(damage)
				queue_free()

	if self.global_position.x < 0 || self.global_position.y < 0 || self.global_position.x > get_viewport_rect().size.x || self.global_position.y > get_viewport_rect().size.y :
		queue_free()
