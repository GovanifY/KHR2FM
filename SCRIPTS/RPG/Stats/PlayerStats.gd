extends "Stats.gd"


# Main stats list for the average Battler
var MAIN_STATS = [
	"lv",
	"max_hp", "max_mp",
	"str", "def"
]

# Final Dictionary with updated values for quick reference
var final = {}

######################
### Core functions ###
######################
func _init(copy={}):
	# General base stats filling
	for stat in MAIN_STATS:
		base[stat] = max(round(copy[stat]), 0) if copy.has(stat) else 0
		final[stat] = base[stat]

	connect("modifier_changed", self, "update")

# Sets final stat values
func _set(stat, value):
	if stat in final:
		# Avoid negative values
		final[stat] = max(round(value), 0)

# Gets calculated final values, so as to not be a performance hit
func _get(stat):
	return final[stat] if stat in final else 0

###############
### Methods ###
###############
func print_stats():
	.print_stats()
	print("Final: ", final.to_json())

# Updates all stats (or just the given one) so as to not over/underflow.
# This is called automatically, but can be called upon request
func update(_=null):
	# Calculate the rest, taking into account that these have changed
	for stat in MAIN_STATS:
		set(stat, min(get(stat), calculate(stat)))
