extends Node2D

# ==============================================================================
# SPAWNING SYSTEM (CODE-ONLY, NO INSPECTOR NEEDED)
# ==============================================================================

### CHANGE #1: SPAWN LESS FREQUENTLY ###
# We will now wait between 4 and 8 seconds for each spawn.
var min_spawn_time: float = 4.0
var max_spawn_time: float = 8.0

# This array will be filled by our code in the _ready() function.
var character_pool: Array[Dictionary] = []
var _total_spawn_weight: float = 0.0

# ==============================================================================
# NODE REFERENCES AND GAME STATE
# ==============================================================================

@onready var jeep = $Jeep
@onready var timer = $PassengerTimer
@onready var characters_container = $Character # Make sure you have a Node2D named "Character"

var score := 0
const MAX_PASSENGERS := 2

# ==============================================================================
# CORE LOGIC
# ==============================================================================

func _ready():
	### CHANGE #2: BUILD THE POOL IN CODE (NO DRAG-AND-DROP) ###
	# This section now loads your scenes directly.
	# !! IMPORTANT !! Make sure these file paths are exactly correct.
	character_pool.append({"scene": load("res://scenes/passenger1.tscn"), "weight": 10})
	character_pool.append({"scene": load("res://scenes/passenger2.tscn"), "weight": 10})
	character_pool.append({"scene": load("res://scenes/bystander.tscn"), "weight": 5})

	# Now that the pool is built, we prepare the systems.
	_calculate_total_weight()
	timer.timeout.connect(_on_timer_timeout)
	
	print("Game Ready. Starting first spawn...")
	_on_timer_timeout()

func _on_timer_timeout():
	_spawn_random_character()
	timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	timer.start()

func _spawn_random_character():
	var chosen_scene = _get_random_weighted_character()
	if chosen_scene == null:
		return

	var character = chosen_scene.instantiate()
	

	var screen_width = get_viewport_rect().size.x
	var spawn_offset_x = (screen_width / 2.0) + 700

	
	character.position = Vector2(jeep.global_position.x + spawn_offset_x, 170)
	
	characters_container.add_child(character)
	print("SUCCESS: Spawned a ", chosen_scene.resource_path)


# ==============================================================================
# HELPER FUNCTIONS (No changes needed here)
# ==============================================================================

func _calculate_total_weight():
	_total_spawn_weight = 0.0
	for item in character_pool:
		_total_spawn_weight += item.weight
	print("Total spawn weight calculated: ", _total_spawn_weight)

func _get_random_weighted_character() -> PackedScene:
	if _total_spawn_weight <= 0:
		printerr("Total spawn weight is zero.")
		return null
		
	var random_pick = randf() * _total_spawn_weight
	var current_weight = 0.0
	
	for item in character_pool:
		current_weight += item.weight
		if random_pick <= current_weight:
			return item.scene
	return null

# ==============================================================================
# EXISTING GAMEPLAY LOGIC (Unchanged)
# ==============================================================================

func on_passenger_picked_up():
	score += 1
	if score >= MAX_PASSENGERS:
		game_over()

func game_over():
	get_tree().paused = true
