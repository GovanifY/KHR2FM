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
	"action" : "",   # Currently executed Animation
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

	play_idle()
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

	if is_facing("left"):
		x *= -1
	return move(Vector2(x, 0))

### Action control
func action_lock():
	Status.lock = true

func action_unlock():
	Status.lock = false

func action_play(name):
	play_anim(name)

func play_idle():
	action_unlock()
	play_anim("Still")

### Facing functions
# Points the body towards the new direction
func face(direction):
	if not (direction in ["left", "right"]):
		return

	if direction.matchn("left"):
		Data.side.x = -1
	elif direction.matchn("right"):
		Data.side.x = 1
	set_scale(Data.side)

# Checks which direction we're going towards
func is_facing(direction):
	if not (direction in ["left", "right"]):
		return false

	if direction.matchn("left"):
		return Data.side.x == -1
	elif direction.matchn("right"):
		return Data.side.x == 1

### Handling animations
func play_anim(anim_name):
	if typeof(Status.action) != TYPE_STRING:
		return false
	if Status.action.matchn(anim_name):
		return false

	Status.action = anim_name
	Data.anims.play(anim_name)
	return true

func stop_anims():
	# If we don't have the reference to the AnimationPlayer nodes, fetch it
	if Data.anims == null:
		if !has_node("anims"):
			return false
		Data.anims = get_node("anims")

	# Chercher tous les Nodes d'animation
	var all_anims = Data.anims.get_children()
	for anim in all_anims:
		anim.stop()

	return true
