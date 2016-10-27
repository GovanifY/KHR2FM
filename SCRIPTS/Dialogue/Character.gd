extends Sprite

# Avatar Constraints
var AVATAR_HEIGHT = OS.get_video_mode_size().height / 2 # Default value

# Export values
export(String) var name = String()
export(int, "Character", "Narrator") var type = 0

# Instance members
var begin = 0
var end   = 0

######################
### Core functions ###
######################
func _ready():
	hide() # Hide it initially
	set_pos(0) # Aligning vertically

###############
### Methods ###
###############
func is_type(type):
	return type == "Character"

func get_pos():
	return .get_pos().x

func set_pos(x):
	# In case we're given a Vector2, we're only accepting the X value
	if typeof(x) == TYPE_VECTOR2:
		x = x.x

	.set_pos(Vector2(x, AVATAR_HEIGHT))

func set_centered(value):
	.set_centered(true)
