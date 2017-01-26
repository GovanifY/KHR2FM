extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#######################
### Signal routines ###
#######################
func _on_TalkArea_body_enter( body ):
	if body.get_name() == "Player":
		set_process_input(true)
		get_node("approach").play("approach")
	
func _on_TalkArea_body_exit( body ):
	if body.get_name() == "Player":
		set_process_input(false)
		
###############
### Methods ###
###############
func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("We should pop up save menu here")
