extends KinematicBody2D

# Signals
signal zero_hp

# Export values
export(NodePath) var AnimTree
export(StringArray) var finisher_voice_se
export(int, 5, 10) var battler_speed = 5
export(int) var max_health = 100

# Instancing objects
const Battle_ActionSet = preload("res://SCRIPTS/Battle/Actions/ActionSet.gd")

# Constants
const STILL_POSE = "Still"
const WALK_POSE = "Walk"

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
var ActionSet

# Global variables
var Motion = Vector2()

######################
### Core functions ###
######################
func _ready():
	add_to_group("Battlers")

	if typeof(AnimTree) == TYPE_NODE_PATH && !AnimTree.is_empty():
		AnimTree = get_node(AnimTree)

	init_stats()
	fight()

func _fixed_process(delta):
	# If the Battler must move
	Motion = move(Motion)
	Motion.x = 0

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

# Custom move() operation
func move_x(specific = battler_speed):
	if typeof(specific) != TYPE_INT:
		specific = battler_speed
	Motion.x = Data.side.x * specific

# Battler timer
func create_timer(wait_time = 0.5, one_shot = false):
	if Data.timer != null:
		Data.timer.free()

	Data.timer = Timer.new()
	Data.timer.set_wait_time(wait_time)
	Data.timer.set_one_shot(one_shot)
	Data.timer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	add_child(Data.timer)

### Facing functions
# Points the body towards the new direction
func adjust_facing(left, right):
	assert(typeof(left) == TYPE_BOOL && typeof(right) == TYPE_BOOL)

	if left && !right:
		Data.side.x = -1
	elif !left && right:
		Data.side.x = 1
	scale(Data.side)

# Checks which direction we're going towards
func is_facing(left, right):
	assert(typeof(left) == TYPE_BOOL && typeof(right) == TYPE_BOOL)

	if left && !right:
		return Data.side.x == -1
	elif !left && right:
		return Data.side.x == 1

### Handling animations
func set_transition(anim_name, idx=0):
	if idx > 0:
		anim_name += str(idx)

	if AnimTree.get_current_animation() != anim_name:
		AnimTree.play(anim_name)

func random_voice(snd_arr):
	var voice = get_node("Voice")
	if typeof(snd_arr) == TYPE_STRING_ARRAY && voice != null:
		var rng = randi() % snd_arr.size()
		voice.play(snd_arr[rng])

### Stats-related functions
func set_stat_representation(idx, node, value):
	if typeof(idx) == TYPE_INT && typeof(node) == TYPE_OBJECT:
		Data[idx] = node
		Data[idx].init(value)

func init_stats():
	set_stat(STAT_HP, max_health)

func set_stat(idx, value):
	Stats[idx] = value
	# If there's a visual representation, update it with new values
	if Data[idx] != null:
		Data[idx].update(value)

func get_stat(idx):
	return Stats[idx]

# Specific helpers
func drain_HP(value):
	value = get_stat(STAT_HP) - int(value)
	if value <= 0:
		value = 0
	set_stat(STAT_HP, value)

	if value == 0:
		emit_signal("zero_hp")
