extends "res://SCRIPTS/Battle/HUD/BattlerHP.gd"

# Instance members
onready var Bubbles = get_node("Bubbles")

######################
### Core functions ###
######################
# FIXME: This function uses division 2 times. Find better algorithm
func set_lifebar(curHP, both = false):
	var len_lifebar = curHP % 100
	var num_bubbles = curHP / 100

	if len_lifebar == 0 && num_bubbles > 0:
		len_lifebar = 100
		num_bubbles -= 1

	set_bubbles(num_bubbles, both)
	return .set_lifebar(len_lifebar, both)

func set_bubbles(num_bubbles, max_bubbles = false):
	Bubbles.set_value(num_bubbles * Bubbles.get_step())

	if max_bubbles:
		var empty_bubbles = get_node("Bubbles/EmptyBubbles")
		if empty_bubbles != null:
			var rect = empty_bubbles.get_region_rect()
			rect.pos.x = -271 + min(15 * num_bubbles, 271)
			empty_bubbles.set_region_rect(rect)
