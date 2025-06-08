extends CharacterBody2D

@export var base_speed := 200.0
var current_speed := base_speed
var is_stopped := false

func _physics_process(delta):
	if !is_stopped:
		velocity.x = current_speed
	else:
		velocity.x = 0
	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		stop_jeep()

func stop_jeep():
	is_stopped = true
	await get_tree().create_timer(1.0).timeout
	is_stopped = false

func set_speed(speed):
	current_speed = speed

func _on_DetectionArea_area_entered(area):
	if is_stopped and area.is_in_group("character"):
		if area.is_passenger:
			area.queue_free()
			get_parent().on_passenger_picked_up()
