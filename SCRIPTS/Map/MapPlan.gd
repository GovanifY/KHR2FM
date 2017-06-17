extends YSort

export(String) var world_name = ""
export(String) var location = ""

func _ready():
	Globals.set("Pause", "world")
	Globals.set("World", world_name)
	Globals.set("Location", location)
