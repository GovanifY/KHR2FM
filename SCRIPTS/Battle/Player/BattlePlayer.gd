extends "../Battler.gd"

# Constants
const STILL_POSE = "Still"
const WALK_POSE = "Walk"

enum {
	ACT_UP = 0x1, ACT_DOWN = 0x2, ACT_LEFT = 0x4, ACT_RIGHT = 0x8,
	ACT_ACCEPT = 0x10, ACT_CANCEL = 0x20,
}

# Instance members
onready var AnimMovement   = get_node("movement")
onready var AnimMethodical = get_node("methodical")
onready var AnimAttack     = get_node("attack")

# "Private" members
var battler_action = {
	ACT_LEFT               : WALK_POSE,
	ACT_RIGHT              : WALK_POSE,
	ACT_CANCEL             : "Guard"  ,
	#ACT_CANCEL | ACT_LEFT : "Roll"   ,
	ACT_ACCEPT             : "Attack" ,
}
var battler_motion = {
	ACT_LEFT             : Vector2(-1,  0),
	ACT_RIGHT            : Vector2( 1,  0),
}

var combo = {
	"counter" : 0,
	"maxed"   : 3,
}

######################
### Core functions ###
######################
func _ready():
	# Setup player data
	setup_data()

	create_timer(0.4, true)
	ComboTimer.connect("timeout", self, "_end_combo")

	# Connecting signals
	AnimMethodical.connect("animation_started", self, "_action_started")
	AnimMethodical.connect("finished", self, "_action_finished")
	AnimAttack.connect("animation_started", self, "_action_started")
	AnimAttack.connect("finished", self, "_action_finished")

	# Player gains control
	set_process_input(true)

func _fixed_process(delta):
	# Simple Input check
	var actions = int(Input.is_action_pressed("left"))  << 2
	actions    |= int(Input.is_action_pressed("right")) << 3

	# Acting
	if battler_action.has(actions):
		_act_battler(actions)
		# Physically moving
		if is_processing_input() && battler_motion.has(actions):
			_move_battler(actions, delta)
	elif AnimMovement.get_current_animation() != STILL_POSE:
		AnimMovement.play(STILL_POSE)

func _input(event):
	var actions = 0
	# If pressed, non-hold
	if event.is_pressed() && !event.is_echo():
		# FIXME: Check if these input maps are correct
		actions |= int(event.is_action("ui_accept")) << 4
		actions |= int(event.is_action("ui_cancel")) << 5

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
		_increment_combo()
		AnimAttack.play(new_anim + String(combo.counter))

func _move_battler(actions, delta):
	var direction = battler_motion[actions]
	# Move it
	var motion = direction * battler_speed * delta
	motion = move(motion)

	# Face it
	direction.y = 1
	set_scale(direction)

### Combo-related
func _increment_combo():
	ComboTimer.start()

	if combo.counter < combo.maxed:
		combo.counter += 1
	else:
		_end_combo()

#######################
### Signal routines ###
#######################
func _action_started(name):
	# TODO: rename animations to support Beginners, Combos and Finishers
	if name == "Guard" || name.begins_with("Attack"):
		set_process_input(false)

func _action_finished():
	set_process_input(true)

func _end_combo():
	ComboTimer.stop()
	combo.counter = 0

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "Player"

func is_type(type):
	return type == get_type()

func fight():
	.fight()
	set_process_input(true)

func at_ease():
	.at_ease()
	set_process_input(false)

### Handling animations
func random_voice(snd_arr):
	var voice = get_node("Voice")
	if typeof(snd_arr) == TYPE_STRING_ARRAY && voice != null:
		var rng = randi() % snd_arr.size()
		voice.play(snd_arr[rng])

func setup_data():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information (LV, STR, DEF, etc.)
		pass
