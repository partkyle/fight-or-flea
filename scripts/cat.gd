extends MovableCharacter
class_name Cat

@onready var animation_player = $AnimationPlayer

@onready var mount_anchor = $MountAnchor

var target: Flea

var mount_manager : MountManager

var mount_damage = 0
var mount_threshold = 3

var direction = -1.0

enum { STATE_MOBILE, STATE_MOUNTED }

var state = STATE_MOBILE


func _ready():
	SPEED = 200

func transition_state(s):
	state = s

func take_mount_damage(body, damage):
	animation_player.current_animation = 'hit'
	get_tree().create_timer(0.2).timeout.connect(func(): animation_player.current_animation = 'RESET')

	mount_damage += damage
	if mount_damage >= mount_threshold:
		mount_damage = 0
		mount_manager.begin_mount(body, self)


func _handle_movement(delta, direction = Vector2.ZERO, jump_pressed = false, dampen = true, extra: Callable = func(): pass):
	if target:
		var distance = target.global_position - global_position
		direction = Util.sign_of(distance.x) * distance.x / distance.x

	super._handle_movement(delta, direction, jump_pressed, dampen, extra)

func _physics_process(delta):
	if state == STATE_MOBILE:
		_handle_movement(delta, direction)
	if state == STATE_MOUNTED:
		if mount_manager.status.status == MountStatus.MOUNT_ANGRY:
			direction = randf_range(-0.1, 0.1)
		else:
			direction = 0
		super._handle_movement(delta, direction)

func _on_los_view_body_entered(body):
	if body is Flea:
		print('gotem')
		target = body

func _on_los_view_body_exited(body):
	if body is Flea:
		print('notem')
		target = null
