extends YSort

export(String) var world_name = ""

func _ready():
	Globals.set("World", world_name)
