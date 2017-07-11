extends "MapEvent.gd"

onready var Approach = get_node("approach")
onready var path_pause = KHR2.get_pause()

func _player_touched():
	if !Approach.is_playing():
		Approach.play("approach")

func _interacted():
	# Switching pause screen
	KHR2.set_pause(load("res://SCENES/Pause/SavePoint.tscn"))

	# Opening SavePoint menu
	var pause = KHR2.get_node("Pause")
	pause.show()
	pause.connect("hide", self, "_dismissed")

func _dismissed():
	# Switching back
	KHR2.set_pause(load(path_pause))
