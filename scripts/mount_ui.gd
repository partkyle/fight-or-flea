extends Control
class_name MountUI

var status: MountStatus

@onready var wrapper = $Wrapper

@onready var progress_bar = $Wrapper/ProgressBar
@onready var cat = $Wrapper/Cat
@onready var player = $Wrapper/AnimationPlayer

@onready var cat_original_position = cat.global_position

func _process(delta):
	if status.status == MountStatus.MOUNT_ANGRY:
		player.current_animation = 'angry'
	elif status.status == MountStatus.MOUNT_WARNING:
		player.current_animation = 'warning'
	else:
		player.current_animation = 'RESET'
		
	progress_bar.value = 100 - status.health_percent()

	cat.global_position.x = cat_original_position.x + (status.rage / 100.0) * wrapper.size.x
