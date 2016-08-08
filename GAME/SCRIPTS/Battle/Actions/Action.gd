const ACTION_GUARD  = 0
const ACTION_COMBO  = 1
const ACTION_FINISH = 2

# Properties of the action to be setup
var Properties = {
	"node"  : null,
	"value" : false,
	"count" : 0     # Number of subsequent actions
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
func _init(node, value, count=1):
	# Checking input
	assert(typeof(node) == TYPE_OBJECT && node.is_type("Battler"))
	assert(typeof(value) == TYPE_BOOL)
	assert(typeof(count) == TYPE_INT && count > 0)

	# Assembling data
	Properties.node = weakref(node)
	Properties.value = value
	Properties.count = count
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
	#var node = Properties.node.get_ref()
	#node.set_transition("attack", 0)
	pass

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

# Action control
func take():
	var node = Properties.node.get_ref()
	node.set_transition("action", true)
	if !Properties.value:
		node.set_transition("attack", ACTION_GUARD)
		return

	if 0 <= Combo.counter && Combo.counter < Properties.count:
		node.set_transition("attack", ACTION_COMBO)
		node.set_transition("combo", -1)
	else:
		node.set_transition("attack", ACTION_FINISH)
		node.set_transition("finisher", -1)
		_end_action()
		return
	_inc_combo()
