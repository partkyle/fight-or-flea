extends Node2D
class_name MountManager

@onready var score = $"../Score"

var status: MountStatus

func begin_mount(flea: Flea, cat: Cat):
	if get_children().size() != 0:
		push_error('status is not nil and we tried to create status. this is a 1 mount at a time game')
		return

	status = MountStatus.new()
	status.score = score
	status.flea = flea
	status.cat = cat
	flea.transition_state(Flea.STATE_MOUNTING)
	cat.transition_state(Cat.STATE_MOUNTED)

	add_child(status)
	
