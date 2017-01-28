tool
extends Area2D

export(Texture) var spriteset setget set_spriteset
export(int) var hframes = 1 setget set_hframes
export(int) var vframes = 1 setget set_vframes
export(int) var frame = 0   setget set_frame
export(int, "Mix", "Add", "Sub", "Mul", "PMAlpha") var blend_mode = 0 setget set_blend_mode
export(NodePath) var Interaction
export(String) var interaction_event
export(NodePath) var Touch
export(String) var touch_event

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

#######################
### Signal routines ###
#######################
func _on_area_body_enter(body):
	if body.get_type() == "MapPlayer":
		if !Interaction.is_empty():
			set_process_input(true)
		if !Touch.is_empty():
			get_node(Touch).play(touch_event)

func _on_area_body_exit(body):
	if body.get_type() == "MapPlayer":
		if !Interaction.is_empty():
			set_process_input(false)

###############
### Methods ###
###############
func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_node(Interaction).play(interaction_event)
