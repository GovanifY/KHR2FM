extends "Stats.gd"


# Maximum stats list
var MAX_STATS = [
	"max_hp", "max_mp"
]

# Main stats list for the average Battler
var MAIN_STATS = [
	"hp", "mp",
	"str", "def"
]

# Final Dictionary with updated values for quick reference
var battle = {}

######################
### Core functions ###
######################
func _init(copy={}):
	# General base stats filling
	for stat in MAX_STATS + MAIN_STATS:
		base[stat] = max(int(copy[stat]), 0) if copy.has(stat) else 0
		battle[stat] = base[stat]

	# Setting maximum values
	for stat in MAIN_STATS:
		var max_stat = "max_" + stat
		if max_stat in MAX_STATS:
			base[max_stat] = max(base[max_stat], 1) # The minimum maximum is 1.
			base[stat] = base[max_stat]
			battle[stat] = base[stat]

	connect("modifier_changed", self, "update")

# General-purpose setter for the available stats (does not account for MAX_STATS)
func _set(stat, value):
	if stat in MAIN_STATS:
		# Avoid negative values
		value = max(int(value), 0)

		# if there's a maximum of the given stat, set the minimum of the two
		var max_stat = "max_" + stat
		base[stat] = min(value, base[max_stat]) if max_stat in MAX_STATS else value

# Getter for final values, so as to be lighter on the CPU
func _get(stat):
	return battle[stat]

###############
### Methods ###
###############
func print_stats():
	.print_stats()
	print("Battle: ", battle.to_json())

func set_max(stat, value):
	value = int(value)
	var max_stat = "max_" + stat
	# If there's a cap, update that and the base stat if it overflows
	if max_stat in MAX_STATS && value > 0:
		base[max_stat] = value
		base[stat] = min(base[stat], value)

# Updates all stats (or just the given one) so as to not over/underflow.
# This is called automatically, but can be called upon request
func update(_=null):
	for stat in battle:
		battle[stat] = .get(stat)
