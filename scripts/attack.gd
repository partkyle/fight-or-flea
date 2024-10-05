extends Node2D
class_name Attack

var mount_damage = 1
var hit = false

var flea : Flea

func _ready():
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Cat and not hit:
		hit = true
		body.take_mount_damage(flea, mount_damage)
