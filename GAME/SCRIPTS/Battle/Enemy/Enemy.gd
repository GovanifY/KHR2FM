extends "res://GAME/SCRIPTS/Battle/Battler.gd"

# Array where our rules will be held
var RuleSet = []

######################
### Core functions ###
######################
func _ready():
	add_to_group("Enemies")

	create_timer(0.5, false)
	Data.timer.connect("timeout", self, "_test_rules")
	Data.timer.start()

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
	return get_HP() < value

###############
### Methods ###
###############
func attack():
	
	pass
func _random_yuugure():
	#Basically either it restarts the animation, either it jumps to attack2
	#(only if player is at least 100 far from him otherwise do nothing)
	#, either it jumps towards you
	#Just after it gets back to the original random state
	pass
func _laser1_yuugure():
	#It loads the laser attack with its own hitbox, enables hit back until
	#0.8 time in Attack1(gives 3HP of damage by default to yuugure) and its hitbox
	#is working until 0.8 where it does the random bs
	pass

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
