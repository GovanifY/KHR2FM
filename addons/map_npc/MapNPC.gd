tool
extends StaticBody2D

export(Texture) var spriteset setget set_spriteset
export(int) var hframes = 1 setget set_hframes
export(int) var vframes = 1 setget set_vframes
export(int) var frame = 0   setget set_frame

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

######################
### Core functions ###
######################
func _enter_tree():
	if !is_a_parent_of(Character):
		add_child(Character)

func _input(event):
	if event.is_action("ui_select"):
		print("I am a random debug NPC. Hi to you random great looking guy")

#######################
### Signal routines ###
#######################
func _on_TalkArea_body_enter( body ):
	if !is_processing_input():
		set_process_input(true)

func _on_TalkArea_body_exit( body ):
	if is_processing_input():
		set_process_input(false)

###############
### Methods ###
###############
