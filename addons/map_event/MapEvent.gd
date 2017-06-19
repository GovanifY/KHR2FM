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

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	if body.is_type("MapPlayer"):
		body.interactable = self
		body.set_process_input(true)

func _on_area_body_exit(body):
	if body.is_type("MapPlayer"):
		body.interactable = null
		body.set_process_input(false)
