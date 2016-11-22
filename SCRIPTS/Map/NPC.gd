extends KinematicBody2D

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action("ui_select"):
		if get_node("./Body").is_colliding():
			print("I am a random debug NPC. Hi to you random great looking guy")
