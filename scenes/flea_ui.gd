extends CanvasLayer

@export var flea: Flea
@export var score: Score

@onready var health_bar = $Control/HealthBar
@onready var eaten_value = $Control/Score/VBoxContainer/Eaten/Value
@onready var failed_value = $Control/Score/VBoxContainer/Failed/Value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = flea.health
	health_bar.max_value = flea.max_health
	eaten_value.text = '%d' % score.eaten
	failed_value.text = '%d' % score.failed
