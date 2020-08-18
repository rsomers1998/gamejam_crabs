extends Node

class_name LevelManager

var crab : PackedScene

var path
var play
var level_active = false
var level_data
var current_level = 0

var h_modifier
var s_modifier

func _init(set_path, set_play):
	self.crab = load('res://Crab.tscn')
	self.path = set_path
	self.play = set_play

	var file = File.new()
	file.open("res://levels.txt", File.READ)
	var content = file.get_as_text()
	level_data = content.split('\n')
	file.close()

func play_level():
	if level_active || path.get_tree().get_nodes_in_group('crabs').size() > 0:
		if path.get_tree().paused == true:
			path.get_tree().paused = false
			play.frame = 1
		else:
			path.get_tree().paused = true
			play.frame = 0
		return
		
	if current_level >= level_data.size():
		play.get_parent().win()
		return

	var level = level_data[current_level].split(' ')
	level_active = true
	play.frame = 1

	s_modifier = 1 + current_level * 0.05
	h_modifier = 1 + current_level * 0.1

	var executable = []
	for i in range(level.size()):
		if level[i].ends_with('('):
			var multiplier = int(level[i].substr(0, level[i].length() - 1))
			var partition = []
			i += 1
			while level[i] != ')':
				partition.append(level[i])
				i += 1
			for _i in range(multiplier - 1):
				for j in partition:
					executable.append(j)
		elif level[i] != ')':
			executable.append(level[i])

	for data in executable:
		match data:
			'c': spawn_crab()
			'f': spawn_fast_crab()
			'vf': spawn_very_fast_crab()
			'b': spawn_big_crab()
			'vb': spawn_very_big_crab()
			var time: yield(path.get_tree().create_timer(float(time)), "timeout")

	level_active = false
	current_level += 1

func spawn_crab():
	var crab_instance = crab.instance()
	crab_instance.add_to_group('crabs')

	var path_follow = PathFollow2D.new()
	path_follow.rotate = false
	path_follow.loop = false
	path.add_child(path_follow)
	path_follow.add_child(crab_instance)

	crab_instance.health = crab_instance.health * h_modifier
	crab_instance.speed = crab_instance.speed * s_modifier

	return crab_instance

func spawn_fast_crab():
	var crab_instance = spawn_crab()

	crab_instance.speed = crab_instance.speed * 2
	crab_instance.scale = Vector2(3,3)
	crab_instance.health = crab_instance.health * 0.7

func spawn_very_fast_crab():
	var crab_instance = spawn_crab()

	crab_instance.speed = crab_instance.speed * 3
	crab_instance.scale = Vector2(2.5,2.5)
	crab_instance.health = crab_instance.health * 0.6

func spawn_big_crab():
	var crab_instance = spawn_crab()

	crab_instance.speed = crab_instance.speed * 0.75
	crab_instance.scale = Vector2(5,5)
	crab_instance.health = crab_instance.health * 5

func spawn_very_big_crab():
	var crab_instance = spawn_crab()

	crab_instance.speed = crab_instance.speed * 0.6
	crab_instance.scale = Vector2(6,6)
	crab_instance.health = crab_instance.health * 10
