extends KinematicBody2D

# Signals
signal zero_hp

# Export values
export(int, 100, 300) var battler_speed = 100 # Pixels/second
export(int, 0, 2000) var max_health = 100
export(int, 0, 1000) var max_mana = 10

# Constants
enum { STAT_BEGIN, STAT_HP, STAT_MP, STAT_STR, STAT_DEF, STAT_END }

var stat_name = {
	STAT_HP  : "HP" ,
	STAT_MP  : "MP" ,
	STAT_STR : "STR",
	STAT_DEF : "DEF",
}

# Important Battler data
onready var Stats = Array()
var ComboTimer

######################
### Core functions ###
######################
func _ready():
	add_to_group(get_type())

	if Globals.get("BattlePlan") != null:
		init_stats()
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

### Stats-related functions
func init_stats():
	var HUD = get_node(NodePath(String(Globals.get("BattlePlan")) + "/HUD"))

	# Preparing Stats array
	Stats.resize(STAT_END)
	# TODO: Setup data representation of each Stat
	for stat in stat_name:
		var node_name = get_type() + stat_name[stat]
		if HUD.has_node(node_name):
			Stats[stat] = HUD.get_node(node_name)

	# Setting their values
	# FIXME: Remove these checks
	if Stats[STAT_HP] != null && Stats[STAT_HP].is_type("DynamicBar"):
		Stats[STAT_HP].set_limit_value(max_health)
	if Stats[STAT_MP] != null && Stats[STAT_MP].is_type("DynamicBar"):
		Stats[STAT_MP].set_limit_value(max_mana)

func get_stat(idx):
	if Stats.has(idx):
		return Stats[idx]
	return 0

func set_stat(idx, value):
	if Stats.has(idx):
		Stats[idx].update(value)
