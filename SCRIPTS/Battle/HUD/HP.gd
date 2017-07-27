extends "DynamicBar.gd"

# Instance members
onready var RedBar = get_node("RedBar")

######################
### Core functions ###
######################
func _ready():
	connect("value_changed", self, "animate_redbar")
	RedBar.connect("changed", self, "reset_redbar")

# RedBar-only methods
func animate_redbar(value):
	if RedBar.get_value() > value:
		_slide(RedBar)
	else:
		reset_redbar()

func reset_redbar(_=0):
	SlideAnim.stop_all()
	RedBar.set_value(get_value())

func resize_redbar(size, new_max):
	RedBar.set_size(size)
	RedBar.set_max(new_max)
