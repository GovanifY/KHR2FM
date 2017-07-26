extends "DynamicBar.gd"

# Instance members
onready var RedBar = get_node("RedBar")

###############
### Methods ###
###############
func set_value(value):
	.set_value(value)

	if RedBar.get_value() > value:
		_slide(RedBar)
	else:
		SlideAnim.stop_all()
		RedBar.set_value(value)

func resize_redbar(size, new_max):
	RedBar.set_size(size)
	RedBar.set_max(new_max)
