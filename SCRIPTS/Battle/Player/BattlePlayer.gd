extends "res://SCRIPTS/Battle/Battler.gd"

# Constants
const STILL_POSE = "Still"
const WALK_POSE = "Walk"

enum {
	ACT_LEFT = 1, ACT_RIGHT = 2, ACT_ACCEPT = 4, ACT_CANCEL = 8,
}

# Export values
export(StringArray) var finisher_voice_se

# Instance members
onready var AnimMovement   = get_node("movement")
onready var AnimMethodical = get_node("methodical")
onready var AnimAttack     = get_node("attack")

# "Private" members
var battler_action = {
	ACT_LEFT               : WALK_POSE ,
	ACT_RIGHT              : WALK_POSE ,
	ACT_CANCEL             : "Guard",
	#ACT_CANCEL | ACT_LEFT : "Roll",
	ACT_ACCEPT             : "Attack"
}
var battler_motion = {
	ACT_LEFT             : Vector2(-1,  0),
	ACT_RIGHT            : Vector2( 1,  0),
}

######################
### Core functions ###
######################
func _ready():
	# Setup player data
	setup_data()

	# Connecting signals
	AnimMethodical.connect("animation_started", self, "_action_started")
	AnimMethodical.connect("finished", self, "_action_finished")
	AnimAttack.connect("animation_started", self, "_action_started")
	AnimAttack.connect("finished", self, "_action_finished")

	# Player gains control
	set_process_unhandled_input(true)

func _fixed_process(delta):
	# Simple Input check
	var actions = int(Input.is_action_pressed("left"))  << 0
	actions    |= int(Input.is_action_pressed("right")) << 1

	# Acting
	if battler_action.has(actions):
		_act_battler(actions)
		# Physically moving
		if is_processing_unhandled_input() && battler_motion.has(actions):
			_move_battler(actions, delta)
	elif AnimMovement.get_current_animation() != STILL_POSE:
		AnimMovement.play(STILL_POSE)

func _unhandled_input(event):
	var actions = 0
	# If pressed, non-hold
	if event.is_pressed() && !event.is_echo():
		# FIXME: Check if these input maps are correct
		actions |= int(event.is_action("ui_accept")) << 2
		actions |= int(event.is_action("ui_cancel")) << 3

	# Acting
	if battler_action.has(actions):
		_act_battler(actions)

func _act_battler(actions):
	var new_anim = battler_action[actions]

	# If it's about movement
	if actions & (ACT_LEFT | ACT_RIGHT) && AnimMovement.get_current_animation() != WALK_POSE:
		AnimMovement.play(new_anim)

	# If it's about methodical actions
	elif actions & ACT_CANCEL:
		AnimMethodical.play(new_anim)

	# If it's about attacking
	elif actions & ACT_ACCEPT:
		# FIXME: adapt to all possible attack animations
		AnimAttack.play(new_anim + "1")

func _move_battler(actions, delta):
	var direction = battler_motion[actions]
	# Move it
	var motion = direction * battler_speed * delta
	motion = move(motion)

	# Face it
	direction.y = 1
	set_scale(direction)

#######################
### Signal routines ###
#######################
func _action_started(name):
	if name == "Guard":
		set_process_unhandled_input(false)
	if name.begins_with("Attack"):
		set_process_unhandled_input(false)

func _action_finished():
	set_process_unhandled_input(true)

###############
### Methods ###
###############
### Overloading functions
func fight():
	.fight()
	set_process_unhandled_input(true)

func at_ease():
	.at_ease()
	set_process_unhandled_input(false)

func setup_data():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information (LV, STR, DEF, etc.)
		pass
