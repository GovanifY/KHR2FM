tool
extends TextureFrame

# Signals
signal frame_changed

# Export values
export(int, "Character", "Narrator") var type = 0
export(SpriteFrames) var face_sprites setget set_face_sprites
export(int, 0, 64) var frame = 0 setget set_frame
export(bool) var flip_h = false setget set_flip_h

# Settings that no one should touch
const SLOT = "default"

# Instance members
onready var name = get_name()
var begin = 0
var end   = 0

########################
### Export functions ###
########################
func set_face_sprites(frames):
	face_sprites = frames
	set_frame(0)

func set_frame(idx):
	if 0 <= idx && idx < face_sprites.get_frame_count(SLOT):
		frame = idx
		set_texture(face_sprites.get_frame(SLOT, idx))

#######################
### Signal routines ###
#######################

######################
### Core functions ###
######################

###############
### Methods ###
###############
func set_pos(pos):
	if typeof(pos) == TYPE_INT:
		pos = Vector2(pos, 0)
	# We're only accepting the X value
	.set_pos(pos)

### FIXME: temporary functions
func get_type():
	return "Character"

func is_type(istype):
	return istype == "Character"

func get_pos():
	var value = .get_size().x
	value += int(value) >> 1
	return value

func set_flip_h(value):
	flip_h = value
	if flip_h:
		set_scale(Vector2(-1, 1))
	else:
		set_scale(Vector2(1, 1))
