extends Camera2D

@onready var target = $"../Flea"

const SPEED = 100

func _process(delta):
	global_position.x = target.global_position.x
