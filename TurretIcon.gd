extends Node

export (PackedScene) var turret

onready var selected = load('res://resources/Selected.png')
onready var instance = turret.instance()
onready var hover = load('res://Label.tscn').instance()

func _ready():
	hover.get_child(0).text = str("Cost ", instance.price, "\nDamage ", instance.damage, "\nReload Time ", stepify(instance.fire_rate,0.01), "\nRange ", instance.turret_range)

func select():
	var sprite = Sprite.new()
	sprite.texture = selected
	add_child(sprite)

func deselect():
	for child in get_children():
		if child is Sprite:
			remove_child(child)

func show_popup():
	if !get_children().has(hover):
		add_child(hover)

func hide_popup():
	if get_children().has(hover):
		remove_child(hover)
