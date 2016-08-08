extends "res://GAME/SCRIPTS/Battle/Battler.gd"

# Array where our rules will be held
var RuleSet = []

# Timer that serves as a delay between actions
var ActionTimer

######################
### Core functions ###
######################
func _ready():
	ActionTimer = Timer.new()
	ActionTimer.set_wait_time(0.5)
	#ActionTimer.set_one_shot(false)
	ActionTimer.set_autostart(true)
	ActionTimer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	ActionTimer.connect("timeout", self, "_test_rules")
	add_child(ActionTimer)
	ActionTimer.start()

func _test_rules():
	for rule in RuleSet:
		if rule.test.callv("call_func", rule.args1):
			rule.result.callv("call_func", rule.args2)
			RuleSet.erase(rule)
			return true

######################
###     Rules      ###
######################
# FIXME: These will be gone after the existence of lambda functions
func HP_less_than(value):
	# TODO
	pass

###############
### Methods ###
###############

################################################################################
#	Rules
# A rule contains the following elements:
# test   : The Boolean function to test, a.k.a. condition
# args1  : Array of Variants to send to the function above
# result : The function to run when the condition set above has been met
# args2  : Array of Variants to send to the function above
################################################################################

func add_rule(test_func, test_args, result_func, result_args):
	if ( # Adding checks is REALLY important here so as to not screw up
	   typeof(test_func) == TYPE_OBJECT && test_func.is_type("FuncRef")
	&& typeof(result_func) == TYPE_OBJECT && result_func.is_type("FuncRef")
	&& typeof(test_args) == TYPE_ARRAY && typeof(result_args) == TYPE_ARRAY
	):
		var rule = {}
		rule.test = test_func
		rule.args1 = test_args
		rule.result = result_func
		rule.args2 = result_args
		RuleSet.push_back(rule)
