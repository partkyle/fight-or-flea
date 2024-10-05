extends Node
class_name MountStatus

const MOUNT_UI = preload("res://scenes/mount_ui.tscn")

var mount_ui : MountUI

var flea : Flea
var cat : Cat
var mount_text

var rage = 0
var max_health = 10
var health = max_health

enum {MOUNT_IDLE, MOUNT_WARNING, MOUNT_ANGRY, MOUNT_FAILED}

var status = MOUNT_IDLE

var pattern = [
	[2, MOUNT_IDLE],
	[1, MOUNT_WARNING],
	[5, MOUNT_ANGRY],
]
var pattern_index = 0
var in_state = false

func _ready():
	mount_ui = MOUNT_UI.instantiate()
	add_child(mount_ui)

func _process(delta):
	_handle_state()
	_handle_input(delta)
	_update_conditions()
	mount_ui.update(self)

func health_percent():
	return (float(health) / float(max_health)) * 100.0

func _update_conditions():
	print(rage, ' ', health_percent())
	if rage > (100 - health_percent()):
		print("you lose")
		flea.toss_off()
		queue_free()
	if health <= 0:
		print("you win")
		flea.toss_off()
		queue_free()
		cat.queue_free()

func _handle_state():
	if in_state:
		return

	in_state = true
	var p = pattern[pattern_index]
	transition_state(p[1])
	await get_tree().create_timer(p[0]).timeout
	pattern_index = (pattern_index + 1) % pattern.size()
	in_state = false

func transition_state(state):
	status = state

func _handle_input(delta):
	if status == MOUNT_IDLE or status == MOUNT_WARNING:
		if Input.is_action_just_pressed("bite"):
			health -= 1
	elif status == MOUNT_ANGRY:
		if Input.is_action_just_pressed("bite"):
			rage += 10
		if Input.is_action_pressed("hold"):
			rage += 0.5 * delta
		else:
			rage += 10 * delta
