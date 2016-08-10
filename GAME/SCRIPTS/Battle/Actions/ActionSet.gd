# Properties of the action to be setup
var Properties = {
	"battler" : null,
	"default" : null
}
var Combo = {
	"timer"   : null,
	"enabled" : false,
	"counter" : 0,
	"maxed"   : 1
}

var ActionList = {}
var action_lock = false

######################
### Core functions ###
######################
func _init(battler, default):
	assert(typeof(battler) == TYPE_OBJECT && battler.is_type("Battler"))
	assert(typeof(default) == TYPE_STRING && !default.empty())

	Properties.battler = battler
	Properties.default = default

func _start_timer():
	Combo.timer.start()

func _stop_timer():
	Combo.timer.stop()

func _inc_combo():
	# Don't bother if there's no Combo.timer attached
	if Combo.timer == null:
		return false

	if Combo.counter == 0:
		Combo.enabled = true

	if Combo.enabled:
		Combo.counter += 1
		_start_timer()
	return true

func _lock():
	action_lock = true

func _unlock():
	action_lock = false

#######################
### Signal routines ###
#######################
func _end_combo():
	Combo.enabled = false
	Combo.counter = 0

func _end_action():
	_unlock()
	Properties.battler.set_transition(Properties.default)

###############
### Methods ###
###############
# Attaches a Timer node to the parent node
func attach_timer(timer):
	if Combo.timer != null:
		Combo.timer.disconnect("timeout", self, "_end_combo")

	if typeof(timer) == TYPE_OBJECT && timer.is_type("Timer"):
		Combo.timer = timer
		Combo.timer.connect("timeout", self, "_end_combo")

func set_max_combo(number):
	if typeof(number) == TYPE_INT && Combo.timer != null:
		Combo.maxed = number

func new_action(name, is_combo = true):
	# FIXME: Much of this code is redundant. Refactor all this shit later
	ActionList[name] = is_combo
	return name

func is_locked():
	return action_lock

# Action control
func take(action):
	if is_locked():
		# Reset the timer in case a combo was attempted
		if ActionList[action]:
			_start_timer()
		return
	_lock()
	# If it's not part of a combo, set it apart
	if !ActionList[action]:
		Properties.battler.set_transition(action)
		return

	if 0 <= Combo.counter && Combo.counter < Combo.maxed:
		# TODO: random combo animations
		Properties.battler.set_transition(action, Combo.counter+1)
		_inc_combo()
	else:
		Properties.battler.set_transition(action, Combo.maxed+1)
		_end_combo()
	return
