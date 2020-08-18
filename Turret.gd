extends Node2D

class_name Turret

enum {FIRST, CLOSE, LAST, STRONG, WEAK}

export (PackedScene) var projectile

export var turret_range : float
export var damage : float
export var fire_rate : float
export var price : int
var turret_target = FIRST
var time : float
var fire_points = []
var point_index = 0

onready var hover = load('res://TargetLabel.tscn').instance()

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	time = fire_rate
	for node in get_children():
		if node is Position2D:
			fire_points.append(node)

func _process(delta):
	var label_target
	match turret_target:
		FIRST:
			label_target = 'First'
		CLOSE:
			label_target = 'Close'
		LAST:
			label_target = 'Last'
		STRONG:
			label_target = 'Strong'
		WEAK:
			label_target = 'Weak'
	hover.get_child(0).text = str('Target\n', label_target)
	hover.global_rotation = 0
	if fire_rate:
		var target = get_target()
		if target:
			turret_rotate(target)
			time -= delta
			if time <= 0:
				time = fire_rate
				fire(target)
				
func turret_rotate(target):
	self.rotation = (self.global_position - target.global_position).angle() - 0.5 * PI

func get_target():
	var crab
	for crab_instance in get_tree().get_nodes_in_group('crabs'):
		if crab_instance.global_position.distance_to(self.global_position) <= turret_range:
			match turret_target:
				FIRST:
					if !crab || crab_instance.get_parent().offset > crab.get_parent().offset:
						crab = crab_instance
				CLOSE:
					if !crab || crab_instance.global_position.distance_to(self.global_position) <= crab.global_position.distance_to(self.global_position):
						crab = crab_instance
				LAST:
					if !crab || crab_instance.get_parent().offset < crab.get_parent().offset:
						crab = crab_instance
				STRONG:
					if !crab || crab_instance.health > crab.health:
						crab = crab_instance
				WEAK:
					if !crab || crab_instance.health < crab.health:
						crab = crab_instance
	return crab

func fire(target):
	var bullet = projectile.instance()
	bullet.set_damage(damage)
	if bullet.has_method('set_target'):
		bullet.set_target(target)
	bullet.global_position = fire_points[point_index].global_position
	bullet.rotation = fire_points[point_index].global_rotation
	point_index = wrapi(point_index + 1, 0, fire_points.size())
	get_parent().add_child(bullet)

func show_popup():
	if !get_children().has(hover):
		add_child(hover)

func hide_popup():
	if get_children().has(hover):
		remove_child(hover)
