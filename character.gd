extends Area2D

@export var is_passenger: bool = true

func _ready():
	if !is_passenger:
		move_bystander()

func move_bystander():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(300, 0), 4.0)
	tween.tween_callback(queue_free)
