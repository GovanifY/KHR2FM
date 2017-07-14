extends KinematicBody2D

# Signals
signal zero_hp

# Export values
export(int, 100, 300) var battler_speed = 100 # Pixels/second
export(int, 0, 2000) var max_health = 100
export(int, 0, 1000) var max_mana = 10

# Constants
enum { STAT_HP, STAT_MP, STAT_STR, STAT_DEF, STAT_END }
var stat_name = [ "HP", "MP", "STR", "DEF", ]

# Instance members
var ComboTimer

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

### Battler timer
func create_timer(wait_time = 0.5, one_shot = false):
	if ComboTimer != null:
		ComboTimer.free()

	ComboTimer = Timer.new()
	ComboTimer.set_wait_time(wait_time)
	ComboTimer.set_one_shot(one_shot)
	ComboTimer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	add_child(ComboTimer)
