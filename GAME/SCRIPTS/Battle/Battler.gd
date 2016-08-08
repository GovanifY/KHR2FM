extends KinematicBody2D

# Constants
const Battle_Action = preload("res://GAME/SCRIPTS/Battle/Actions/Action.gd")

# Important Battler data
onready var AnimTree = get_node("AnimTree")
var Data = {
	# Various properties
	"side"  : Vector2(1, 1),
}

# Status des actions du Battler
var Status = {
	"lock"   : false
}

# Lists
var Actions = {}

# Global variables
var Motion

######################
### Core functions ###
######################
func _ready():
	start_anims()
	set_fixed_process(true)

func _fixed_process(delta):
	# If the Battler must move
	if Motion != 0:
		var motion = move_x(Motion)

func _random_voice(snd_arr):
	var voice = get_node("Voice")
	if typeof(snd_arr) == TYPE_STRING_ARRAY && voice != null:
		var rng = randi() % snd_arr.size()
		voice.play(snd_arr[rng])

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "Battler"

func is_type(type):
	return get_type() == type

# Custom move() operation
func move_x(x):
	if typeof(x) != TYPE_INT:
		return Vector2(0, 0)

	x *= Data.side.x
	return move(Vector2(x, 0))

### Action control
func action_lock():
	Status.lock = true

func action_unlock():
	Status.lock = false

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
func start_anims():
	if AnimTree == null:
		return false
	if !AnimTree.is_active():
		AnimTree.set_active(true)
	return true

func play_anim(anim_name, idx):
	if typeof(idx) == TYPE_BOOL:
		idx = int(idx)
	AnimTree.transition_node_set_current(anim_name, idx)

func stop_anims():
	if AnimTree != null:
		AnimTree.set_active(false)
