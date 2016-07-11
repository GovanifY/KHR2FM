extends CanvasLayer

# Instance members
var SE = {
	"name" : null,
	"node" : null
}
var anims = null
var icon  = null

######################
### Core functions ###
######################
func _ready():
	# Preparing confirm key
	icon = get_node("icon")
	anims = get_node("anims")
	# Preparing sound effect confirmation
	SE.node = get_node("default")
	SE.name = "MSG_SOUND"

###############
### Methods ###
###############
func init():
	pass

func set_SE(SENode = null, SEName = null):
	# If ANY of them are null, use the default SE
	if SENode == null || SEName == null:
		SENode = get_node("default")
		SEName = "MSG_SOUND"
	SE.node = SENode
	SE.name = SEName

func play_SE():
	if SE.node != null:
		SE.node.play(SE.name)

#######################
### Signal routines ###
#######################
func play_anim():
	icon.show()
	anims.play("Keyblade Hover")

func stop_anim():
	anims.stop()
	icon.hide()
