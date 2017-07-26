extends KinematicBody2D

# Signals
signal zero_hp

# Classes
const BattlerStats = preload("res://SCRIPTS/RPG/Stats/BattlerStats.gd")

# Export values
export(int, 100, 300) var battler_speed = 100 # Pixels/second

# Instance members
var stats

######################
### Core functions ###
######################
func _ready():
	add_to_group("Battler")
	fight()

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "Battler"

func is_type(type):
	return get_type() == type

func set_y(y):
	var x = get_pos().x
	set_pos(Vector2(x, y))

### Battler control
func fight():
	set_fixed_process(true)

func at_ease():
	set_fixed_process(false)
