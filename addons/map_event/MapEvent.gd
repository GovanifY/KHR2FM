tool
extends Area2D

# Signals
signal touched
signal interacted

######################
### Core functions ###
######################
func _enter_tree():
	# Setting up
	set_pickable(true)
	connect("body_enter", self, "_on_area_body_enter")
	connect("body_exit", self, "_on_area_body_exit")

func _input(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			emit_signal("interacted")

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	if body.get_type() == "MapPlayer":
		body.interactable = self
		body.set_process_input(true)

func _on_area_body_exit(body):
	if body.get_type() == "MapPlayer":
		body.interactable = null
		body.set_process_input(false)
