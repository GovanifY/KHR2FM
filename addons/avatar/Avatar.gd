tool
extends Control

# Export values
export(int, "Character", "Narrator") var type = 0
export(SpriteFrames) var face_sprites   setget set_face_sprites
export(int, 0, 64)   var frame = 0      setget set_frame
export(bool)         var flip_h = false setget set_flip_h

# Settings that no one should touch
const SLOT = "default"

# Instance members
onready var name = get_name()
var Avatar = Sprite.new()

########################
### Export functions ###
########################
func set_face_sprites(frames):
	face_sprites = frames
	set_frame(0)

func set_frame(idx):
	if face_sprites == null || Avatar == null:
		return
	if 0 <= idx && idx < face_sprites.get_frame_count(SLOT):
		frame = idx
		Avatar.set_texture(face_sprites.get_frame(SLOT, idx))

#######################
### Signal routines ###
#######################

######################
### Core functions ###
######################
func _enter_tree():
	add_child(Avatar)
	set_focus_mode(FOCUS_NONE)
	set_draw_behind_parent(true)

###############
### Methods ###
###############
func set_pos(pos):
	pos.y = int(OS.get_video_mode_size().height) >> 1
	# We're only accepting the X value
	.set_pos(pos)

### FIXME: temporary functions
func get_type():
	return "Character"

func is_type(istype):
	return istype == get_type()

func set_flip_h(value):
	if Avatar == null:
		return
	flip_h = value
	Avatar.set_flip_h(value)
