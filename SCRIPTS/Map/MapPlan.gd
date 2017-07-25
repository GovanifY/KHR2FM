extends YSort

export(String) var world_name = ""
export(String) var location = ""

func _enter_tree():
	KHR2.set_pause(preload("res://SCENES/Menus/SimplePause.tscn"))

func _exit_tree():
	undefine_map()
	KHR2.set_pause(null)

func _ready():
	define_map()

func define_map():
	KHR2.get("Map").world = world_name
	KHR2.get("Map").location = location

	# Setting props and MapEvents
	get_tree().call_group(0, "MapEnemy", "hide")

func undefine_map():
	pass
