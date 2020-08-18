extends Node2D

var waiting = 0
var health = 5
var money = 20

var selected_turret

export var selectable : Color

onready var path = $Path2D
onready var label = $Label
onready var map = $Sprite.texture.get_data()
onready var play = $Sprite2
onready var LevelManager = load('res://LevelManager.gd')
onready var lvlmanager = LevelManager.new(path, play)
onready var winlose = load('res://WinLose.tscn')
onready var info = $Sprite3
onready var info_hover = load('res://Info.tscn').instance()

func _process(_delta):
	label.text = str('Health\n', health, '\n\nMoney\n',  money)
	if health <= 0:
		play.frame = 2
		var lose = winlose.instance()
		lose.frame = 1
		add_child(lose)
		set_process(false)
	elif !lvlmanager.level_active && get_tree().get_nodes_in_group('crabs').size() == 0:
		play.frame = 0

func _input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		var mouse = get_global_mouse_position()
		if mouse.x >= 1200:
			for node in get_tree().get_nodes_in_group('turrets'):
				if is_over(node, mouse):
					selected_turret = node.turret
					node.select()
				else:
					node.deselect()
			for node in get_tree().get_nodes_in_group('buttons'):
				if node.frame == 2:
					var _x = get_tree().reload_current_scene()
					return
				if is_over(node, mouse):
					lvlmanager.play_level()
		else:
			var map_mouse = Vector2(stepify(mouse.x - 40, 80) + 40, stepify(mouse.y - 40, 80) + 40)
			var normalised_mouse = (map_mouse - Vector2(40, 40)) / 80
			map.lock()
			if selected_turret && selectable && map.get_pixel(normalised_mouse.x, normalised_mouse.y).to_abgr32() == selectable.to_abgr32():
				var new_turret = selected_turret.instance()
				new_turret._ready()
				if(new_turret.price <= money):
					for child in get_children():
						if child is Turret && child.global_position == map_mouse:
							if child.price == new_turret.price:
								return
							child.queue_free()
					money -= new_turret.price
					new_turret.global_position = map_mouse
					new_turret.scale = Vector2(4, 4)
					add_child(new_turret)
					new_turret.add_to_group('map_turrets')
				else:
					new_turret.queue_free()
			map.unlock()
	elif event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_RIGHT:
		var mouse = get_global_mouse_position()
		for node in get_tree().get_nodes_in_group('map_turrets'):
			if is_over(node, mouse):
				node.turret_target = wrapi(node.turret_target + 1, 0, 5)
	elif event is InputEventMouseMotion:
		var mouse = get_global_mouse_position()
		if mouse.x >= 1200:
			for node in get_tree().get_nodes_in_group('turrets'):
				if is_over(node, mouse):
					node.show_popup()
				else:
					node.hide_popup()
			if is_over(info, mouse):
				if !get_children().has(info_hover):
					add_child(info_hover)
			elif get_children().has(info_hover):
				remove_child(info_hover)
		else:
			for node in get_tree().get_nodes_in_group('turrets'):
				node.hide_popup()
			for node in get_tree().get_nodes_in_group('map_turrets'):
				if is_over(node, mouse):
					node.show_popup()
				else:
					node.hide_popup()

func is_over(node, mouse):
	var icon_size
	var icon_position = node.global_position
	if node is Sprite:
		icon_size = node.texture.get_size() * node.scale * 0.5
	else:
		icon_size = node.get_child(0).texture.get_size() * node.scale * 0.5
	return mouse.x >= icon_position.x - icon_size.x && mouse.x <= icon_position.x + icon_size.x && mouse.y >= icon_position.y - icon_size.y && mouse.y <= icon_position.y + icon_size.y
	
func win():
	set_process(false)
	play.frame = 2
	add_child(winlose.instance())
