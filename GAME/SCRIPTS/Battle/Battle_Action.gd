# Signals
#signal started
signal combo
signal finished

# Timers
var ComboTimer = null

# Properties of the action to be setup
var Properties = {
	"action" : null,  # InputAction to be linked to
	"name"   : null,  # Name of the action
	"count"  : 0,     # Number of subsequent actions
	"anim"   : null   # Animation node
}
var IEvent = {
	"pressed" : false,
	"echo"    : false
}
# List of animation names to load
var AnimList = []

# Temporary data to keep updating as everything goes along
var Course = {
	"counter" : 0,
	"combo"   : false
}

######################
### Core functions ###
######################
# Assembles input data to create an action; shouldn't do a thing if data is insufficient
func _init(anims, name, action, count=0):
	# Checking input
	assert(anims != null)
	assert(typeof(action) == TYPE_STRING && !action.empty())
	assert(typeof(name)   == TYPE_STRING)
	assert(typeof(count)  == TYPE_INT && count >= 0)

	# Assembling data
	#set_name("Action" + name)
	Properties.action = action
	Properties.anim = anims.get_node(name)

	if count > 0:
		Properties.count = count
		for i in range(1, count+1):
			AnimList.push_back("%s%d" % [name, i])
	else:
		Properties.count = 1
		AnimList.push_back(name)

	# TODO: abort if data is insufficient
	# Connecting animation
	Properties.anim.connect("finished", self, "_end_action")

	return true

func _start_timer():
	ComboTimer.start()

func _stop_timer():
	ComboTimer.stop()

func _inc_combo():
	# Don't bother if there's no ComboTimer attached
	if ComboTimer == null:
		return false

	if Course.counter == 0:
		Course.combo = true

	if Course.combo:
		_start_timer()
		Course.counter += 1
		#emit_signal("combo")
	return true

#######################
### Signal routines ###
#######################
func _end_combo():
	Course.combo = false
	Course.counter = 0
	_end_action()

func _end_action():
	emit_signal("finished")

###############
### Methods ###
###############
# Property modifiers
func set_event(e, value):
	IEvent[e] = value

func set_timer(value):
	ComboTimer = value
	ComboTimer.connect("timeout", self, "_end_combo")

# InputEvent checks
func is_echo(event):
	if IEvent.echo:
		return event.is_echo()
	return !event.is_echo()

func is_pressed(event):
	if IEvent.pressed:
		return event.is_pressed()
	return !event.is_pressed()

# Action control
func check_event(event):
	return event.is_action(Properties.action) && is_pressed(event) && is_echo(event)

func take_event(event):
	#if !Properties.anim.is_playing()
	if Course.counter < Properties.count:
		Properties.anim.play(AnimList[Course.counter])
		_inc_combo()
		return true

	return false
