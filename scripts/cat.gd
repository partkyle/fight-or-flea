extends CharacterBody2D
class_name Cat

@onready var mount_manager = $"../MountManager"
@onready var mount_anchor = $MountAnchor
@onready var mount_area = $MountArea

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var mount_damage = 0
var mount_threshold = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func take_mount_damage(body, damage):
	mount_damage += damage
	if mount_damage >= mount_threshold:
		mount_damage = 0
		mount_manager.begin_mount(body, self)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _on_mount_point_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Flea:
		mount_manager.begin_mount(body, self)
