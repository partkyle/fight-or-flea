extends CanvasLayer


@onready var standard_controls = $Control/StandardControls
@onready var mount_controls = $Control/MountControls
@onready var mount_manager = $"../MountManager"


const CONTROLLER: ControlIcons = preload("res://resources/controller.tres")
const KEYBOARD: ControlIcons = preload("res://resources/keyboard.tres")
const MOUSE: ControlIcons = preload("res://resources/mouse.tres")

enum {INPUT_KEY, INPUT_MOUSE, INPUT_CONTROLLER}

var input_method = INPUT_KEY

@onready var standard_move_icon = $Control/StandardControls/Move/Icon
@onready var standard_bite_icon = $Control/StandardControls/Bite/Icon
@onready var standard_jump_icon = $Control/StandardControls/Jump/Icon
@onready var standard_dash_icon = $Control/StandardControls/Dash/Icon
@onready var mount_bite_icon = $Control/MountControls/Bite/Icon
@onready var mount_hold_icon = $Control/MountControls/Hold/Icon


var ever_mouse = true

func _input(event):
	if event is InputEventMouse:
		input_method = INPUT_MOUSE
		ever_mouse = true
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		input_method = INPUT_CONTROLLER
	elif not ever_mouse:
		input_method = INPUT_KEY

	_update_input_method()

func _update_input_method():
	var icons : ControlIcons
	if input_method == INPUT_KEY:
		icons = KEYBOARD
	elif input_method == INPUT_MOUSE:
		icons = MOUSE
	elif input_method == INPUT_CONTROLLER:
		icons = CONTROLLER

	standard_move_icon.texture = icons.move_icon
	standard_bite_icon.texture = icons.bite_icon
	standard_jump_icon.texture = icons.jump_icon
	standard_dash_icon.texture = icons.dash_icon
	mount_bite_icon.texture = icons.bite_icon
	mount_hold_icon.texture = icons.hold_icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mount_manager.active():
		standard_controls.hide()
		mount_controls.show()
	else:
		standard_controls.show()
		mount_controls.hide()


func _on_timer_timeout():
	ever_mouse = false
