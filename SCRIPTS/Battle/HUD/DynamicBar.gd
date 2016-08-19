extends TextureProgress

# Instance members
onready var SlideAnim = get_node("SlideAnim")

###############
### Methods ###
###############
func update(new_val):
	set_value(new_val)

######################
### Core functions ###
######################
func reset_anim():
	SlideAnim.reset_all()
	SlideAnim.remove_all()
	SlideAnim.set_repeat(false)
