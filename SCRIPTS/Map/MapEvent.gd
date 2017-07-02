extends Area2D

# Signals
signal touched
signal interacted

# Export values
export(String) var type = ""

onready var Save = "res://SCENES/Pause/LoadMenu.tscn"

######################
### Core functions ###
######################
func _enter_tree():
	# Setting up
	set_pickable(true)
	connect("body_enter", self, "_on_area_body_enter")
	connect("body_exit", self, "_on_area_body_exit")


func _interacted():
	if get_type() == "MapSave":
		get_tree().set_pause(true)
		SceneLoader.load_scene(Save, SceneLoader.BACKGROUND | SceneLoader.HIGH_PRIORITY)		
		SceneLoader.show_scene(Save)
		# TODO: kill input on root scene

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	if get_type() == "MapSave" || get_type() == "MapPlayer":
		body.interactable = self


func _on_area_body_exit(body):
	if get_type() == "MapSave" || get_type() == "MapPlayer":
		# If player entered another area this area might be wanted
		if body.interactable == self:
			body.interactable = null

########################
### Export functions ###
########################
func get_type():
	return type

func is_type(type):
	return type == get_type()
