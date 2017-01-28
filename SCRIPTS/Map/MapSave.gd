extends Area2D

#######################
### Signal routines ###
#######################
func _on_TalkArea_body_enter( body ):
	if body.get_type() == "MapPlayer":
		set_process_input(true)
		# FIXME: Find a better way to implement this
		get_node("../approach").play("approach")

func _on_TalkArea_body_exit( body ):
	if body.get_type() == "MapPlayer":
		set_process_input(false)

###############
### Methods ###
###############
func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("We should pop up save menu here")
