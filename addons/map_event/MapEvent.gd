tool
extends Area2D

# Signals
signal touched
signal interacted

# Spriteset values
export(Texture) var spriteset setget set_spriteset
export(int) var hframes = 1 setget set_hframes
export(int) var vframes = 1 setget set_vframes
export(int) var frame = 0   setget set_frame
export(int, "Mix", "Add", "Sub", "Mul", "PMAlpha") var blend_mode = 0 setget set_blend_mode

# Instance members
var Character = Sprite.new()

########################
### Export functions ###
########################
func set_spriteset(value):
	spriteset = value
	Character.set_texture(value)

func set_hframes(value):
	if value > 0:
		hframes = value
		Character.set_hframes(value)

func set_vframes(value):
	if value > 0:
		vframes = value
		Character.set_vframes(value)

func set_frame(idx):
	if 0 <= idx && idx < vframes * hframes:
		frame = idx
		Character.set_frame(idx)

func set_blend_mode(value):
	blend_mode = value
	Character.set_blend_mode(value)

######################
### Core functions ###
######################
func _enter_tree():
	# Adding children
	if !is_a_parent_of(Character):
		add_child(Character)

	# Setting up
	set_pickable(true)
	connect("body_enter", self, "_on_area_body_enter")
	connect("body_exit", self, "_on_area_body_exit")

func _input(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			emit_signal("interacted")

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	emit_signal("touched")
	if body.get_type() == "MapPlayer":
		body.interactable = self
		body.set_process_input(true)

func _on_area_body_exit(body):
	if body.get_type() == "MapPlayer":
		body.interactable = null
		body.set_process_input(false)
