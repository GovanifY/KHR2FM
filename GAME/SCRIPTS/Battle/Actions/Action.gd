# Signals
signal combo(name, counter)
signal finished

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
var Combo = {
	"timer"   : null,
	"enabled" : false,
	"counter" : 0,
	"max"     : 1
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
	if Combo.timer != null:
		Combo.timer.start()

func _stop_timer():
	if Combo.timer != null:
		Combo.timer.stop()

func _inc_combo():
	# Don't bother if there's no Combo.timer attached
	if Combo.timer == null:
		return false

	if Combo.counter == 0:
		Combo.enabled = true

	if Combo.enabled:
		_start_timer()
		Combo.counter += 1
	return true

#######################
### Signal routines ###
#######################
func _end_combo():
	Combo.enabled = false
	Combo.counter = 0
	_end_action()

func _end_action():
	emit_signal("finished")

###############
### Methods ###
###############
# Property modifiers
func set_event(e, value):
	IEvent[e] = value

# Attaches a Timer node to the parent node
func create_timer(parent):
	if not (typeof(parent) == TYPE_OBJECT && parent.is_type("Battler")):
		return

	if Combo.timer != null:
		Combo.timer.disconnect("timeout", self, "_end_combo")
		Combo.timer.free()

	Combo.timer = Timer.new()
	Combo.timer.set_wait_time(0.3)
	Combo.timer.set_one_shot(true)
	Combo.timer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	Combo.timer.connect("timeout", self, "_end_combo")
	parent.add_child(Combo.timer)

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
	if Combo.counter < Properties.count:
		var name = Properties.name
		if Properties.count > 1:
			name +=  str(Combo.counter+1)
		emit_signal("combo", name)
		if Callback.active:
			Callback.fn.call_func(Callback.args)
		_inc_combo()
		return true

	return false
