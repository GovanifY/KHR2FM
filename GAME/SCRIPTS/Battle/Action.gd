# Signals
signal combo(name, counter)
signal finished

# Timers
var ComboTimer = null

# Properties of the action to be setup
var Properties = {
	"action" : null,  # InputAction to be linked to
	"name"   : null,
	"count"  : 0     # Number of subsequent actions
}
var Callback = {
	"active" : false,
	"fn"     : null,
	"args"   : null
}
var IEvent = {
	"pressed" : false,
	"echo"    : false
}

# Temporary data to keep updating as everything goes along
var Course = {
	"counter" : 0,
	"combo"   : false
}

######################
### Core functions ###
######################
# Assembles input data to create an action; shouldn't do a thing if data is insufficient
func _init(name, action, count=1):
	# Checking input
	assert(typeof(action) == TYPE_STRING && !action.empty())
	assert(typeof(name)   == TYPE_STRING)
	assert(typeof(count)  == TYPE_INT && count > 0)

	# Assembling data
	Properties.name = name
	Properties.action = action
	Properties.count = count

	# TODO: abort if data is insufficient
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

func set_callback(node, callback, args):
	Callback.active = true
	Callback.fn     = funcref(node, callback)
	Callback.args   = args

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
	return event.is_action(Properties.action) && (is_pressed(event) && is_echo(event))

func take_event(event):
	if Course.counter < Properties.count:
		emit_signal("combo", Properties.name, Course.counter)
		if Callback.active:
			Callback.fn.call_func(Callback.args)
		_inc_combo()
		return true

	return false
