extends CharacterBody2D
class_name MovableCharacter

var SPEED = 300.0
var JUMP_VELOCITY = -400.0

var jump_count = 0
var max_jump_count = 1

var last_input_dir := 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _handle_movement(delta, direction = Vector2.ZERO, jump_pressed = false, dampen = true, extra: Callable = func(): pass):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	# Handle jump.
	if jump_pressed and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	if (last_input_dir > 0 and direction < 0) or (last_input_dir < 0 and direction > 0):
		flip_horizontal()

	if direction:
		velocity.x = direction * SPEED
		last_input_dir = direction
	elif dampen:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	extra.call()

	move_and_slide()

func flip_horizontal():
	scale.x = -1
