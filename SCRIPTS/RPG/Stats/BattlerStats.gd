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
		base[stat] = max(round(copy[stat]), 0) if copy.has(stat) else 0
		battle[stat] = base[stat]

	# Setting maximum values
	for stat in MAIN_STATS:
		var max_stat = "max_" + stat
		if max_stat in MAX_STATS:
			base[max_stat] = max(base[max_stat], 1) # The minimum maximum is 1.
			base[stat] = base[max_stat]
			battle[stat] = base[stat]

	connect("modifier_changed", self, "update")

# Sets battle stat values
func _set(stat, value):
	if stat in battle:
		# Avoid negative values
		value = max(round(value), 0)

		# If it's a max_stat, no need for complicated stuff
		if stat.begins_with("max_"):
			battle[stat] = value
		else:
			# If there's a maximum of the given stat, set the minimum of the two
			var max_stat = "max_" + stat
			battle[stat] = min(value, battle[max_stat]) if max_stat in MAX_STATS else value

# Gets calculated battle values, so as to not be a performance hit
func _get(stat):
	return battle[stat] if stat in battle else 0

###############
### Methods ###
###############
func print_stats():
	.print_stats()
	print("Battle: ", battle.to_json())

# Sets maximum base value (this is useful since it also updates its counterpart)
func set_max(stat, value):
	value = round(value)
	var max_stat = "max_" + stat
	# If there's a cap, update that and the base stat if it overflows
	if max_stat in MAX_STATS && value > 0:
		set_base(max_stat, value)
		set_base(stat, min(get_base(stat), value))

# Updates all stats (or just the given one) so as to not over/underflow.
# This is called automatically, but can be called upon request
func update(_=null):
	# Calculate maximum stats FIRST
	for stat in MAX_STATS:
		set(stat, calculate(stat))

	# Calculate the rest, taking into account that these have changed
	for stat in MAIN_STATS:
		set(stat, min(get(stat), calculate(stat)))
