extends "res://SCRIPTS/Battle/HUD/HP.gd"

# Constants
const MAXIMUM_ENEMY_HP = 1800 # num_layers * get_max()

# Instance members
onready var GreenBar = get_node("GreenBar")
onready var UnderBar = get_node("UnderBar")

# "Private" members
var max_num_layers = 0

###############
### Methods ###
###############
func set_max_value(value):
	value = value if value <= MAXIMUM_ENEMY_HP else MAXIMUM_ENEMY_HP
	.set_max_value(value)

	# Changing opacity of the background bar if value != max
	if value != get_max():
		UnderBar.set_opacity(0.1)
		GreenBar.set_opacity(0.1)

######################
### Core functions ###
######################
func set_value(value, both = false):
	var len_lifebar = value % 100
	var num_layers = value / 100

	# If value reaches a multiple of 100, decrement num_layers
	if len_lifebar == 0 && num_layers > 0:
		len_lifebar = 100
		num_layers -= 1

	if num_layers < max_num_layers:
		UnderBar.set_opacity(1.0)
		GreenBar.set_opacity(0)

	set_layers(num_layers, both)
	return .set_value(len_lifebar, both)

func set_layers(num_layers, num_layers_is_max = false):
	var Layers = get_node("Layers")
	var EmptyLayers = Layers.get_node("EmptyLayers")

	Layers.set_value(num_layers * Layers.get_step())

	if num_layers_is_max:
		max_num_layers = num_layers
		if EmptyLayers != null:
			var rect = EmptyLayers.get_region_rect()
			rect.pos.x = -271 + min(15 * num_layers, 271)
			EmptyLayers.set_region_rect(rect)
