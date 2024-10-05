extends Node2D
class_name MountManager

var status : MountStatus = null

func begin_mount(flea: Flea, cat: Cat):
	if status:
		push_error('status is not nil and we tried to create status. this is a 1 mount at a time game')

	status = MountStatus.new()
	status.flea = flea
	status.cat = cat
	flea.transition_state(Flea.STATE_MOUNTING)

	add_child(status)
	
