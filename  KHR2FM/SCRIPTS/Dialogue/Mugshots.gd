extends CanvasLayer

# Signals
signal switched_side
#signal switched_mugshot

# Instance members
var This = {
	"side"    : false,  # false --> left, true --> right
	"specify" : false,
	"posx"    : [0, 0],
	"nodes"   : [null, null]
}

######################
### Core functions ###
######################
# Mugshot animation control
func _anim_mugshot_in(character, anim_node = "SlideIn"):
	var i = int(This.side)
	var from = _get_side_string(i)
	var anim_player = get_node(anim_node)
	var anim = anim_player.get_animation(from)

	# If the animation can't be loaded, just set its position
	if anim == null:
		This.nodes[i].set_pos(Vector2(This.posx[i], 0))
		return

	# Setting NodePath
	var path = character.name + ":transform/pos"
	anim.track_set_path(0, path)

	# Playing the animation
	This.nodes[i].set_pos(Vector2(-440, 0))
	anim_player.play(from)

func _anim_mugshot_out(character, anim_node = "FadeOut"):
	var i = int(This.side)
	var anim_player = get_node(anim_node)
	var anim = anim_player.get_animation("Normal")

	# If the animation can't be loaded, just hide it
	if anim == null:
		This.nodes[i].hide()
		return

	# Setting NodePath
	var path = character.name + ":visibility/opacity"
	anim.track_set_path(0, path)

	# Playing the animation
	anim_player.play("Normal")

########################
### Helper functions ###
########################
static func _get_side_string(side):
	if !side:
		return "Left"
	else:
		return "Right"

###############
### Methods ###
###############
func init(dialogue):
	# Preparing mugshot info
	This.posx[1] = OS.get_window_size().width - 440

	# Connecting signals
	get_node("SlideIn").connect("finished", dialogue, "_open_dialogue")

# Switches mugshots
func switch_character(character):
	if character.mugshot == null:
		return true

	var i = int(This.side)
	# if it contains a node but is the same as argument
	if This.nodes[i] == character.mugshot:
		return true
	# if we need to switch a previously stored mugshot
	elif This.nodes[i] != null:
		This.nodes[i].hide()

	# Make the switch
	This.nodes[i] = character.mugshot
	This.nodes[i].set_flip_h(This.side)
	# Show it
	_anim_mugshot_in(character)
	This.nodes[i].show()
	return false

# Inverts side
func switch_side():
	This.side = !This.side
	emit_signal("switched_side")

func get_side():
	return This.side

func is_specified():
	return This.specify

func set_specify(value):
	This.specify = value
