extends Camera2D

@onready var target = $"../Flea"

const SPEED = 100

@export var FOLLOW_DISTANCE = 100

func _process(delta):
	var distance = abs(global_position.x - target.global_position.x)
	if distance > FOLLOW_DISTANCE:
		global_position.x = lerp(global_position.x, target.global_position.x, 4.0 * delta)
