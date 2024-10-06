extends Node
class_name MountStatus

const MOUNT_UI = preload("res://scenes/mount_ui.tscn")

const BITE_COOLDOWN = 0.2
var can_bite = true

var score: Score

var mount_ui : MountUI

var flea : Flea
var cat : Cat

var flea_original_position: Vector2

var rage = 0
var max_health = 10
var health = max_health

enum {MOUNT_IDLE, MOUNT_WARNING, MOUNT_ANGRY, MOUNT_FAILED}

var status = MOUNT_IDLE

var pattern = [
	[0.5, 2.0, MOUNT_IDLE],
	[1.0, 2.0, MOUNT_WARNING],
	[3.0, 5.0, MOUNT_ANGRY],
]
var pattern_index = 0
var in_state = false

var setup = false

func _ready():
	var tween = get_tree().create_tween()
	flea_original_position = flea.global_position
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_method(migrate_flea, flea.global_position, cat.mount_anchor.global_position, 1.0)

	await tween.finished

	flea.mount(cat, cat.mount_anchor)

	mount_ui = MOUNT_UI.instantiate()
	mount_ui.status = self
	add_child(mount_ui)
	
	setup = true

func migrate_flea(pos: Vector2):
	flea.global_position = pos

func _process(delta):
	if not setup:
		return

	_handle_state()
	_handle_input(delta)
	_update_conditions()

func health_percent():
	return (float(health) / float(max_health)) * 100.0

func _update_conditions():
	if rage > (100 - health_percent()):
		flea.toss_off()
		cat.transition_state(Cat.STATE_MOBILE)
		queue_free()
		flea.health -= 1
		score.failed += 1

	if health <= 0:
		flea.toss_off()
		queue_free()
		cat.queue_free()
		score.eaten += 1
		flea.health = min(flea.max_health, flea.health+1)

func _handle_state():
	if in_state:
		return

	in_state = true
	var p = pattern[pattern_index]
	transition_state(p[2])
	await get_tree().create_timer(randf_range(p[0], p[1])).timeout
	pattern_index = (pattern_index + 1) % pattern.size()
	in_state = false

func transition_state(state):
	status = state

func _handle_input(delta):
	if status == MOUNT_IDLE or status == MOUNT_WARNING:
		if Input.is_action_just_pressed("bite") and can_bite and !Input.is_action_pressed("hold"):
			can_bite = false
			health -= 1
			await get_tree().create_timer(BITE_COOLDOWN).timeout
			can_bite = true
	elif status == MOUNT_ANGRY:
		if Input.is_action_just_pressed("bite"):
			rage += 10
		if Input.is_action_pressed("hold"):
			rage += 0.5 * delta
		else:
			rage += 20 * delta
