extends Sprite

# Export values
export(int, "Character", "Narrator") var type = 0

# Instance members
onready var name = get_name()
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
func set_pos(pos):
	if typeof(pos) == TYPE_INT:
		pos = Vector2(pos, 0)
	pos.y = int(OS.get_video_mode_size().height) >> 1
	# We're only accepting the X value
	.set_pos(pos)

### FIXME: temporary functions
func get_type():
	return "Character"

func is_type(istype):
	return istype == "Character"

func get_pos():
	return .get_pos().x
