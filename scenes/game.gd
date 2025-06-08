extends Node2D

@onready var jeep = $Jeep
@onready var timer = $PassengerTimer
@onready var characters_container = $Characters

@export var passenger_scene_1: PackedScene
@export var passenger_scene_2: PackedScene
@export var bystander_scene: PackedScene

var score := 0
const MAX_PASSENGERS := 2

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_random_character()

func spawn_random_character():
	var pool = [passenger_scene_1, passenger_scene_2, bystander_scene]
	var chosen = pool[randi() % pool.size()]
	var c = chosen.instantiate()
	c.position = Vector2(jeep.position.x + randf_range(400, 600), 400)
	characters_container.add_child(c)

func on_passenger_picked_up():
	score += 1
	if score >= MAX_PASSENGERS:
		game_over()



func game_over():
	get_tree().paused = true
