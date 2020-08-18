extends KinematicBody2D

var health = 10.0
var speed = 100
var index = 0

onready var follow = get_parent()
onready var main = get_parent().get_parent().get_parent()

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	$AnimationPlayer.play("Walking")

func _process(delta):
	follow.offset += speed * delta

	if follow.unit_offset >= 1.0:
		get_parent().get_parent().get_parent().health -= 1
		queue_free()

func damage(value):
	health -= value
	if health <= 0:
		main.money += 5
		queue_free()