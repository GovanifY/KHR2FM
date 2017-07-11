extends YSort

export(String) var world_name = ""
export(String) var location = ""

func _enter_tree():
	define_map()
	KHR2.set_pause(preload("res://SCENES/Pause/SimplePause.tscn"))

func _exit_tree():
	undefine_map()
	KHR2.set_pause(null)

func define_map():
	Globals.get("Map").world = world_name
	Globals.get("Map").location = location

func undefine_map():
	pass
