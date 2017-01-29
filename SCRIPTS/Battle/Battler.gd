extends KinematicBody2D

# Signals
signal zero_hp

# Export values
export(int, 100, 300) var battler_speed = 100 # Pixels/second
export(int) var max_health = 100

const STAT_HP  = 0
const STAT_STR = 1
const STAT_DEF = 2

# Important Battler data
var Stats = [
	max_health, # HP
	0,          # STR
	0           # DEF
]
var Data = {
	# Various properties
	"side"  : Vector2(1, 1), # Scale data that will determine the Battler's side
	"timer" : null,
	# Nodes
	STAT_HP : null
}

######################
### Core functions ###
######################
func _ready():
	add_to_group("Battlers")

	init_stats()
	fight()

func _fixed_process(delta):
	pass

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "Battler"

func is_type(type):
	return get_type() == type

### Battler control
func fight():
	set_fixed_process(true)

func at_ease():
	set_fixed_process(false)

### Battler timer
func create_timer(wait_time = 0.5, one_shot = false):
	if Data.timer != null:
		Data.timer.free()

	Data.timer = Timer.new()
	Data.timer.set_wait_time(wait_time)
	Data.timer.set_one_shot(one_shot)
	Data.timer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	add_child(Data.timer)

### Handling animations
func random_voice(snd_arr):
	var voice = get_node("Voice")
	if typeof(snd_arr) == TYPE_STRING_ARRAY && voice != null:
		var rng = randi() % snd_arr.size()
		voice.play(snd_arr[rng])

### Stats-related functions
func set_stat_representation(idx, node, value):
	if typeof(idx) == TYPE_INT && typeof(node) == TYPE_OBJECT:
		Data[idx] = node
		Data[idx].set_limit_value(value)

func init_stats():
	set_stat(STAT_HP, max_health)

func set_stat(idx, value):
	Stats[idx] = value
	# If there's a visual representation, update it with new values
	if Data.has(idx) && Data[idx] != null:
		Data[idx].update(value)

func get_stat(idx):
	return Stats[idx]
