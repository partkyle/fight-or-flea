extends CharacterBody2D
class_name Flea

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var flea : Sprite2D = $Flea

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 100
var max_jump_count = 2

var state = 'mobile'

var last_input_dir : Vector2

func mount(cat: Cat, anchor: Node2D):
	global_position = anchor.global_position
	transition_state('mount')

func transition_state(s):
	state = s

func _handle_mobile_movement(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0
	
	if last_input_dir.x < 0:
		flea.flip_h = true
	else:
		flea.flip_h = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		last_input_dir = velocity
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _handle_mount_movement(delta):
	pass

func _physics_process(delta):
	if state == 'mobile':
		_handle_mobile_movement(delta)
	if state == 'mount':
		_handle_mount_movement(delta)

func toss_off():
	state = 'mobile'
	velocity.y = JUMP_VELOCITY * 1.0
	jump_count = 1
