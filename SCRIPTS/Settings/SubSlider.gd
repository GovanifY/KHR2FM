extends "Subsetting.gd"

######################
### Core functions ###
######################
func _ready():
	control.connect("value_changed", self, "_changed")

#######################
### Signal routines ###
#######################
func _changed(value):
	if !KHR2.config.has_section(name):
		print("Setting '", name, "' doesn't exist in configuration file.")
		return
	elif !KHR2.config.has_section_key(name, controls):
		print("Setting '", name, "' doesn't have '", controls, "' key in configuration file.")
		return
	emit_signal("changed", value)
