extends KinematicBody2D

# Export values
export(int, 5, 10) var battler_speed = 5
export(int) var hit_points = 100 setget set_HP,get_HP

# Constants
const Battle_Action = preload("res://GAME/SCRIPTS/Battle/Actions/Action.gd")

# Important Battler data
onready var AnimTree = get_node("AnimTree")
var HP_Bar setget set_hp_bar
var Data = {
	# Various properties
	"side"  : Vector2(1, 1),
}

# Lists
var Actions = {}

# Global variables
var Motion = Vector2()

######################
### Core functions ###
######################
func _ready():
	add_to_group("Battlers")
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
	if AnimTree != null:
		if !AnimTree.is_active():
			AnimTree.set_active(true)

func at_ease():
	set_fixed_process(false)
	if AnimTree != null:
		AnimTree.set_active(false)

# Custom move() operation
func move_x(specific = battler_speed):
	if typeof(specific) != TYPE_INT:
		specific = battler_speed
	Motion.x = Data.side.x * specific

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
func set_transition(anim_name, idx):
	if typeof(idx) == TYPE_BOOL:
		idx = int(idx)
	elif idx == -1:
		idx = randi() % AnimTree.transition_node_get_input_count(anim_name)

	AnimTree.transition_node_set_current(anim_name, idx)

func random_voice(snd_arr):
	var voice = get_node("Voice")
	if typeof(snd_arr) == TYPE_STRING_ARRAY && voice != null:
		var rng = randi() % snd_arr.size()
		voice.play(snd_arr[rng])

# HP-related functions
func set_HP(value):
	if typeof(value) == TYPE_INT || typeof(value) == TYPE_REAL:
		# Updating HP bar first
		if HP_Bar != null:
			HP_Bar.update(hit_points, value)
		hit_points = value

func get_HP():
	return hit_points

func set_hp_bar(value):
	if typeof(value) == TYPE_OBJECT:
		HP_Bar = value
