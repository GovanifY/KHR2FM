extends KinematicBody2D

# Constants
const Battle_Action = preload("res://GAME/SCRIPTS/Battle/Actions/Action.gd")

# Important Battler data
var Data = {
	# Various properties
	"side"  : Vector2(1, 1),
	# Nodes
	"anims" : null   # AnimationPlayer node which contains all needed animations
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
	Data.anims = get_node("anims")
	play_anim("Still")
	set_fixed_process(true)

func _fixed_process(delta):
	# If the Battler must move
	if Motion != 0:
		play_anim("Walk")
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

func action_play(name):
	play_anim(name)

### Facing functions
# Points the body towards the new direction
func adjust_facing(left, right):
	assert(typeof(left) == TYPE_BOOL && typeof(right) == TYPE_BOOL)

	if left && !right:
		Data.side.x = -1
	else:
		Data.side.x = 1
	scale(Data.side)

# Checks which direction we're going towards
func is_facing(left, right):
	assert(typeof(left) == TYPE_BOOL && typeof(right) == TYPE_BOOL)

	if left && !right:
		return Data.side.x == -1
	else:
		return Data.side.x == 1

### Handling animations
func play_anim(anim_name):
	if Data.anims == null:
		return false
	if typeof(anim_name) != TYPE_STRING:
		return false
	if Data.anims.get_current_animation().matchn(anim_name):
		return false

	Data.anims.play(anim_name)
	Data.anims.queue("Still")
	return true

func stop_anims():
	if Data.anims != null:
		Data.anims.stop()
