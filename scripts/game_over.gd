extends CanvasLayer
class_name GameOver

const GAME = preload("res://scenes/game.tscn")

@onready var back_drop = $BackDrop

var is_game_over = false
var game_over_delay = false

@onready var level = $"../Level"

var game: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	if game:
		game.queue_free()

	game_over_delay = false
	is_game_over = false

	game = GAME.instantiate()
	game.game_over.connect(game_over)

	print('connecting to gme over sig ', game)

	level.add_child(game)

	back_drop.hide()

func game_over():
	back_drop.show()
	is_game_over = true
	await get_tree().create_timer(1.0).timeout
	game_over_delay = true

func _input(event):
	if not is_game_over or not game_over_delay:
		return

	if event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventKey:
		new_game()
