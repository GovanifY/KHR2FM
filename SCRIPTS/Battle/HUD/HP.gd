extends "res://SCRIPTS/Battle/HUD/DynamicBar.gd"

# Instance members
onready var RedBar = get_node("RedBar")

###############
### Methods ###
###############
func update(value, animate_red=false):
	.update(value)

	if RedBar != null:
		if animate_red:
			_reset_anim()
			_play_anim(RedBar)
		else:
			RedBar.set_value(value)
