extends Sprite

# Export values
export(String) var name = String()
export(int, "Character", "Narrator") var type = 0

# Instance members
var begin = 0
var end   = 0

# "Private" members
const self_type = "Character"

######################
### Core functions ###
######################
func _ready():
	add_to_group(self_type)

	hide() # Hide it initially
	set_pos(0) # Aligning vertically

###############
### Methods ###
###############
func is_type(type):
	return type == self_type

func get_pos():
	return .get_pos().x

func set_pos(x):
	# In case we're given a Vector2, we're only accepting the X value
	if typeof(x) == TYPE_VECTOR2:
		x = x.x

	.set_pos(Vector2(x, int(OS.get_video_mode_size().height) >> 1))
