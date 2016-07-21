extends CanvasLayer

######################
### Core functions ###
######################
func _set_HP(HP):
	var GreenBar = get_node("GreenBar")
	Greenbar.set_scale(Vector2(HP/100,0)
