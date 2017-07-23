tool
extends Control

# Signals
signal finished

# Export values
export(SpriteFrames) var face_sprites   setget set_face_sprites
export(int, 0, 64)   var frame = 0      setget set_frame
export(bool)         var flip_frame = false setget set_flip

# Settings that no one should touch
const SLOT = "default"

# Instance members
var sprite = Sprite.new()

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
		sprite.set_texture(face_sprites.get_frame(SLOT, idx))

######################
### Core functions ###
######################
func _enter_tree():
	# Adding children nodes
	if !is_a_parent_of(sprite):
		add_child(sprite)

	# Setting up
	set_draw_behind_parent(true)
	set_size(Vector2(1, 1))

###############
### Methods ###
###############
func get_center():
	return get_global_pos().x

func get_off_bounds():
	var ret = Vector2(sprite.get_texture().get_size().x, 0)
	# Drag animation from left or right depending on the situation
	if !is_flipped():
		ret.x *= -1
	return ret

func get_type():
	return "Avatar"

func is_type(istype):
	return istype == get_type()

func is_flipped():
	return sprite.is_flipped_h()

func set_flip(value):
	if sprite == null:
		return
	flip_frame = value
	sprite.set_flip_h(value)

func set_side(right):
	var Dialogue = Globals.get("Dialogue")

	var left_side  = Dialogue.CastLeft
	var right_side = Dialogue.CastRight

	# Fitting avatar in the Dialogue window
	if Dialogue.is_a_parent_of(self):
		Dialogue.remove_child(self)
	elif left_side.is_a_parent_of(self) && right:
		left_side.remove_child(self)
	elif right_side.is_a_parent_of(self) && not right:
		right_side.remove_child(self)

	if right:
		right_side.add_child(self)
	else:
		left_side.add_child(self)

	# Flipping the character's sprite by default (will always reset when)
	set_flip(right)

# Methods from Dialogue node
func speak(begin, end=begin):
	var Dialogue = Globals.get("Dialogue")
	Dialogue.speak(self, begin, end)

func display():
	var Dialogue = Globals.get("Dialogue")
	Dialogue.display(self)

func dismiss():
	var Dialogue = Globals.get("Dialogue")
	Dialogue.dismiss(self)

func silence():
	var Dialogue = Globals.get("Dialogue")
	Dialogue.silence(self)
