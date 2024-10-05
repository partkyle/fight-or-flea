extends CharacterBody2D
class_name Flea

const ATTACK = preload("res://scenes/attack.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DODGE_MULTIPLIER = 10.0
const DODGE_COOLDOWN = 0.2
var can_dodge = true

@onready var flea : Sprite2D = $Flea
@onready var attack_container = $AttackContainer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 100
var max_jump_count = 2

enum {STATE_MOBILE, STATE_MOUNTING, STATE_MOUNTED, STATE_THROWN}
var state = STATE_MOBILE

var last_input_dir : float

func mount(cat: Cat, anchor: Node2D):
	transition_state(STATE_MOUNTED)
	global_position = anchor.global_position 

func transition_state(s):
	state = s

func _handle_mobile_movement(delta):
	_handle_movement(delta)

	if Input.is_action_just_pressed("bite") and attack_container.get_children().size() == 0:
		var attack = ATTACK.instantiate()
		attack.flea = self
		attack_container.add_child(attack)

func _handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")

	if (last_input_dir > 0 and direction < 0) or (last_input_dir < 0 and direction > 0):
		flip_horizontal()
		
	if direction:
		velocity.x = direction * SPEED
		last_input_dir = direction
	elif state == STATE_MOBILE:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_handle_dodge()

	move_and_slide()

func flip_horizontal():
	scale.x = -1

func _handle_mount_movement(delta):
	pass

func _handle_dodge():
	if Input.is_action_just_pressed('dodge') and can_dodge:
		can_dodge = false
		velocity.x *= DODGE_MULTIPLIER

		get_tree().create_timer(DODGE_COOLDOWN).timeout.connect(func(): can_dodge = true)

func _physics_process(delta):
	if state == STATE_MOBILE:
		_handle_mobile_movement(delta)
	if state == STATE_MOUNTED:
		_handle_mount_movement(delta)
	if state == STATE_THROWN:
		_handle_movement(delta)

func toss_off():
	disable_cat_collision()
	velocity.y = JUMP_VELOCITY
	velocity.x = JUMP_VELOCITY * randf_range(-1.0, 1.0)
	jump_count = 1
	transition_state(STATE_THROWN)
	
	await get_tree().create_timer(1.0).timeout
	
	enable_cat_collision()
	state = STATE_MOBILE

func disable_cat_collision():
	set_collision_mask_value(3, false)
	
func enable_cat_collision():
	set_collision_mask_value(3, true)
