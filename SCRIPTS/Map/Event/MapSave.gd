extends "MapEvent.gd"

onready var path_pause = KHR2.get_pause()

func _interacted():
	KHR2.set_pause(load("res://SCENES/Pause/SavePoint.tscn"))
	KHR2.get_node("Pause").connect("hide", self, "_dismissed")

func _dismissed():
	KHR2.set_pause(load(path_pause))
