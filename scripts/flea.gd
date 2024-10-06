extends MovableCharacter
class_name Flea

const ATTACK = preload("res://scenes/attack.tscn")

const DODGE_MULTIPLIER = 10.0
const DODGE_COOLDOWN = 0.2
var can_dodge = true

@onready var flea : Sprite2D = $Flea
@onready var attack_container = $AttackContainer

enum {STATE_MOBILE, STATE_MOUNTING, STATE_MOUNTED, STATE_THROWN}
var state = STATE_MOBILE

var anchor: Node2D

func _ready():
	max_jump_count = 2
	SPEED = 300.0
	JUMP_VELOCITY = -400.0

func mount(cat: Cat, a: Node2D):
	transition_state(STATE_MOUNTED)
	anchor = a

func transition_state(s):
	# clean up the mounted state so we don't see a bug related to a missing node
	if state == STATE_MOUNTED:
		anchor = null

	state = s

func _handle_mobile_movement(delta):
	_handle_movement(delta)

	if Input.is_action_just_pressed("bite") and attack_container.get_children().size() == 0:
		var attack = ATTACK.instantiate()
		attack.flea = self
		attack_container.add_child(attack)

func _handle_movement(delta, direction = Vector2.ZERO, jump_pressed = false, dampen = true, extra: Callable = func(): pass):
	super._handle_movement(
		delta,
		Input.get_axis("move_left", "move_right"),
		Input.is_action_just_pressed("jump"),
		state == STATE_MOBILE,
		_handle_dodge,
		)

func flip_horizontal():
	scale.x = -1

func _handle_mount_movement(delta):
	if anchor:
		global_position = anchor.global_position

func _handle_dodge():
	if Input.is_action_just_pressed('dodge') and can_dodge:
		can_dodge = false
		velocity.x *= DODGE_MULTIPLIER

		await get_tree().create_timer(DODGE_COOLDOWN).timeout
		can_dodge = true

func _physics_process(delta):
	if state == STATE_MOBILE:
		_handle_mobile_movement(delta)
	if state == STATE_MOUNTED:
		_handle_mount_movement(delta)
	if state == STATE_THROWN:
		_handle_movement(delta)

func toss_off():
	disable_cat_collision()
	velocity.y = JUMP_VELOCITY * 1.5
	velocity.x = JUMP_VELOCITY * randf_range(-1.5, 1.5)
	jump_count = 1
	transition_state(STATE_THROWN)
	
	await get_tree().create_timer(1.0).timeout
	
	enable_cat_collision()
	state = STATE_MOBILE

func disable_cat_collision():
	set_collision_mask_value(3, false)
	
func enable_cat_collision():
	set_collision_mask_value(3, true)
