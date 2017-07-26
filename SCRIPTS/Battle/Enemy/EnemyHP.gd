extends "res://SCRIPTS/Battle/HUD/HP.gd"

# Constants
const MAX_HP_MOD = 100

# Instance members
const OneLayer = preload("res://SCENES/Battle/Enemy/HPLayer.tscn")
onready var Layers = get_node("Layers")

# "Private" members
var top_layer_size
var maximum = 0
var max_layers = 0
var green_layers = 0

######################
### Core functions ###
######################
func _ready():
	OneLayer.set_block_signals(true)
	.set_max(MAX_HP_MOD) # Maximum value should always be 100

###############
### Methods ###
###############
# Sets up all available HP (including bars) of our enemy
func set_max(value):
	maximum = value

	# Grabbing percentage values
	var bar_data = split(value)
	var new_value = bar_data[0]
	max_layers = bar_data[1]

	# Setting values
	.set_value(new_value)

	# Resizing HP bar
	top_layer_size = get_size()
	top_layer_size.width = int(top_layer_size.width * new_value / 100.0)
	RedBar.set_size(top_layer_size)

	# Clear any previous nodes available in Layers
	for layer in Layers.get_children():
		layer.queue_free()

	# Instancing the number of layers obtained
	for idx in range(max_layers):
		var layer = OneLayer.instance()
		Layers.add_child(layer)
		layer.set_pos(Vector2(idx * layer.get_size().x, 0))

func get_max():
	return maximum

func set_value(value):
	# FIXME: optimize this portion by avoiding various split() calls
	var bar_data = split(value)
	.set_value(bar_data[0])

	# Update green layers only if necessary
	var num_layers = bar_data[1]
	if num_layers != green_layers:
		green_layers = num_layers
		for layer in Layers.get_children():
			if num_layers > 0:
				num_layers -= 1
				layer.set_value(1)
			else:
				layer.set_value(0)

	# Updating HP bar size if we have full bars
	if green_layers == max_layers && RedBar.get_size() != top_layer_size:
		print("Setting max HP size")
		RedBar.set_size(top_layer_size)
	# Revert it otherwise
	elif green_layers != max_layers && RedBar.get_size() == top_layer_size:
		print("Setting normal HP size")
		RedBar.set_size(get_size())

static func split(value):
	# Grabbing data
	value = int(value)
	var current_val = value % MAX_HP_MOD
	var num_layers  = value / MAX_HP_MOD

	# Correcting math in case mod of HP == 0
	if current_val == 0 && num_layers > 0:
		current_val = MAX_HP_MOD
		num_layers -= 1

	return [current_val, num_layers]
