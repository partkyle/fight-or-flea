extends Node

const CAT = preload("res://scenes/cat.tscn")
@onready var mount_manager = $"../MountManager"

@onready var player = $"../Flea"

const EVERY = 500

var spawned = [0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cat_index = floori(player.global_position.x) / EVERY
	if cat_index not in spawned:
		spawned.push_back(cat_index)
		var cat = CAT.instantiate()
		cat.mount_manager = mount_manager
		add_child(cat)
		cat.global_position.x = cat_index * EVERY + (EVERY + randi_range(0, 100)) * Util.sign_of(cat_index)
		cat.global_position.y = 200
