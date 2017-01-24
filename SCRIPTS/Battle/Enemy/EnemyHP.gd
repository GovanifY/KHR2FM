extends "res://SCRIPTS/Battle/HUD/HP.gd"

# Constants
const MAX_HP_MOD = 100		# A new layer is added every MAX_HP_MOD
const MAX_HP_LAYERS = 20	# Maximum number of HP layers an enemy can have
const LAYER_POS = Vector2(20, 12)

# Instance members
const OneLayer = preload("res://SCENES/Battle/Enemy/HPLayer.tscn")
onready var Layers = get_node("Layers")

# "Private" members
var max_num_layers = 0

###############
### Methods ###
###############
func update(value, animate_red=true):
	var data = _prepare_bar_data(value)
	var num_layers_to_alter = max_num_layers - data[1]

	# Updating health bar
	.update(data[0], animate_red && get_value() >= data[0])

	# Updating layer bars
	# FIXME: optimize this portion
	var all_layers = Layers.get_children()
	for i in range(max_num_layers):
		var index = max_num_layers - (i+1)
		if i < num_layers_to_alter:
			all_layers[index].set_value(0)
		else:
			all_layers[index].set_value(1)

func set_limit_value(value):
	.set_limit_value(value)

	# Preparing bars
	var data = _prepare_bar_data(value)
	_set_layers(data[1])
	update(value, false)

######################
### Core functions ###
######################
func _set_layers(num_layers):
	var different = max_num_layers != num_layers
	max_num_layers = num_layers

	if different:
		for child in Layers.get_children():
			child.queue_free()

		for i in range(num_layers):
			# Creating node
			var temp_node = OneLayer.instance()

			# Setting its position
			var new_pos = LAYER_POS
			new_pos.x *= (i+1)
			temp_node.set_pos(new_pos)
			Layers.add_child(temp_node)

func _prepare_bar_data(value):
	# Grabbing data
	var current_val = value % MAX_HP_MOD
	var num_layers = int(value / MAX_HP_MOD)

	# Correcting math in case mod of HP == 0
	if current_val == 0:
		current_val = MAX_HP_MOD
		num_layers -= 1

	# Limiting number of layers to avoid ridiculous amounts of HP
	if num_layers > MAX_HP_LAYERS:
		num_layers = MAX_HP_LAYERS

	return [current_val, num_layers]
