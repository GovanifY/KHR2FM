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
	print("yo")
	if get_type() == "MapSave":
		SceneLoader.load_scene(Save, SceneLoader.BACKGROUND | SceneLoader.HIGH_PRIORITY)		
		SceneLoader.show_scene(Save)
		#TODO: kill input on root scene


#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	body.interactable = self


func _on_area_body_exit(body):
	body.interactable = null

########################
### Export functions ###
########################
func get_type():
	return type

func is_type(type):
	return type == get_type()
