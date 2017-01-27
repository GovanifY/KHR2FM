tool
extends Control

# Export values
export(SpriteFrames) var face_sprites   setget set_face_sprites
export(int, 0, 64)   var frame = 0      setget set_frame
export(bool)         var flip_h = false setget set_flip_h

# Settings that no one should touch
const SLOT = "default"

# Instance members
var Avatar = Sprite.new()

########################
### Export functions ###
########################
func set_face_sprites(frames):
	face_sprites = frames
	set_frame(0)

func set_frame(idx):
	if face_sprites == null:
		return
	if 0 <= idx && idx < face_sprites.get_frame_count(SLOT):
		frame = idx
		Avatar.set_texture(face_sprites.get_frame(SLOT, idx))

######################
### Core functions ###
######################
func _enter_tree():
	# Adding children nodes
	if !is_a_parent_of(Avatar):
		add_child(Avatar)

	# Setting up
	set_draw_behind_parent(true)
	set_size(Vector2(1, 1))

###############
### Methods ###
###############
func get_center():
	return get_pos().x

func get_type():
	return "Avatar"

func is_type(istype):
	return istype == get_type()

func set_flip_h(value):
	if Avatar == null:
		return
	flip_h = value
	Avatar.set_flip_h(value)

func set_side(right):
	var Dialogue = get_node(Globals.get("Dialogue"))

	if Dialogue == null:
		print("No Dialogue node instanced. What are you even doing, foo??")
		return

	var CastLeft  = Dialogue.get_node("CastLeft")
	var CastRight = Dialogue.get_node("CastRight")

	# Fitting avatar in the Dialogue window
	if Dialogue.is_a_parent_of(self):
		Dialogue.remove_child(self)
	elif CastLeft.is_a_parent_of(self) && right:
		CastLeft.remove_child(self)
	elif CastRight.is_a_parent_of(self) && !right:
		CastRight.remove_child(self)

	if right:
		CastRight.add_child(self)
	else:
		CastLeft.add_child(self)

	# Flipping the character's sprite by default (will always reset when)
	set_flip_h(right)
