extends "res://SCRIPTS/Battle/Battler.gd"


export(int, 1, 20) var enemy_instances = 1
export(bool) var random_instances = false

######################
### Core functions ###
######################
func _ready():
	add_to_group("Enemy")
	if enemy_instances > 1:
		enemy_instances -= 1 # Don't count the already available instance

		# Use RNG if requested; otherwise, use the exact number requested
		enemy_instances = randi() % enemy_instances if random_instances else enemy_instances

		# Disable random_instances regardless of its former value
		random_instances = false
		call_deferred("instance_next")

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "Enemy"

func is_type(type):
	return type == get_type()

func instance_next():
	var new_enemy = duplicate()
	get_parent().call_deferred("add_child", new_enemy)

	# Fixing positions
	# TODO: fix new_enemy node's positions so they don't stack on one another
