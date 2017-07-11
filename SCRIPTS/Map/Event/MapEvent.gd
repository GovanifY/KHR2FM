extends Area2D

# Signals
signal touched
signal interacted

# Export values
export(String) var type = ""

######################
### Core functions ###
######################
func _ready():
	# Setting up
	set_pickable(false)
	connect("interacted", self, "_interacted")
	connect("body_enter", self, "_on_area_body_enter")
	connect("body_exit", self, "_on_area_body_exit")

func _player_touched():
	pass # Called when a MapPlayer has entered the area

func _interacted():
	pass # Called when interacted signal is emitted

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	if body.is_type("MapPlayer") && not body.has_interacting(self):
		body.add_interacting(self)
		_player_touched()

func _on_area_body_exit(body):
	if body.is_type("MapPlayer") && body.has_interacting(self):
		body.erase_interacting(self)

########################
### Export functions ###
########################
func get_type():
	return type

func is_type(type):
	return type == get_type()
