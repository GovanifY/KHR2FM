extends KinematicBody2D

# Export values
export(int, 5, 10) var battler_speed = 5
export(int) var hit_points = 100 setget set_HP,get_HP

# Constants
const STILL_POSE = "Still"
const WALK_POSE = "Walk"

# Instancing objects
const Battle_ActionSet = preload("res://GAME/SCRIPTS/Battle/Actions/ActionSet.gd")

# Important Battler data
onready var AnimTree = get_node("anims")
var HP_Bar setget set_hp_bar
var Data = {
	# Various properties
	"side"  : Vector2(1, 1), # Scale data that will determine the Battler's side
	"timer" : null
}
var ActionSet

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
