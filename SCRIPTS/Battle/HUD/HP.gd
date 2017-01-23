extends "res://SCRIPTS/Battle/HUD/DynamicBar.gd"

# Instance members
onready var MaxBar = get_node("MaxBar")
onready var RedBar = get_node("RedBar")

###############
### Methods ###
###############
func set_max_value(value):
	.set_max_value(value)
	# Setting progress bars
	set_value(value, true)

	# Setting MaxBar size
	value %= int(get_max())
	if value == 0:
		value = int(get_max())

	var width = MaxBar.get_texture().get_width()
	var rect = MaxBar.get_region_rect()
	var new_width = int(round(width * value / get_max()))
	var amount = width - new_width

	rect.pos.x = amount
	rect.size.width = new_width
	MaxBar.set_offset(Vector2(amount, 0))
	MaxBar.set_region_rect(rect)

func update(new_val):
	if new_val > max_value:
		new_val = max_value

	var is_set = set_value(new_val)
	if !is_set:
		reset_anim()
		play_anim(RedBar)

######################
### Core functions ###
######################
### Control methods
func set_value(value, both = false):
	.set_value(value)

	if value >= RedBar.get_value():
		both = true
	if both:
		RedBar.set_value(get_value())

	return both
