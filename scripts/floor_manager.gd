extends Node2D

const FLOOR = preload("res://scenes/floor.tscn")

@onready var floors = get_children()
@onready var target = $"../Flea"

const FLOOR_WIDTH = 640

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var distances = {}
	for floor in floors:
		var distance = target.global_position.x - floor.global_position.x
		print(floor, ' ', distance)

		distances[distance] = floor

	var min_floor = null
	var min_distance = 10000
	for distance in distances:
		if abs(distance) < min_distance:
			min_distance = abs(distance)
			min_floor = distances[distance]

	for distance in distances:
		var floor = distances[distance]
		if abs(distance) > FLOOR_WIDTH * 1.5:
			floor.global_position.x = min_floor.global_position.x +  FLOOR_WIDTH * sign_of(distance)

func sign_of(f: float):
	if f < 0:
		return -1
	else:
		return 1
