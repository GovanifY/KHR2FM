extends Button

# Cursor sprite
export(NodePath) var cursor
var cursor_inc = 0

######################
### Core functions ###
######################
func _ready():
	connect("pressed", SE, "play", ["system_confirm"])
	connect("focus_enter", SE, "play", ["system_selected"])
	connect("focus_enter", self, "_got_focus")

	if cursor != null:
		cursor = get_node(cursor)
		cursor_inc = cursor.get_texture().get_size() / 4

#######################
### Signal routines ###
#######################
func _got_focus():
	if cursor != null:
		var pos = get_pos() + cursor_inc
		cursor.set_pos(pos)

###############
### Methods ###
###############
# Overrides
func grab_focus():
	disconnect("focus_enter", SE, "play")
	.grab_focus()
	connect("focus_enter", SE, "play", ["system_selected"])

func set_focus_mode(value):
	.set_focus_mode(value)

	if cursor == null:
		return # Nothing else to do here

	if value == FOCUS_NONE && !cursor.is_hidden():
		cursor.hide()
	elif value in [FOCUS_CLICK, FOCUS_ALL] && cursor.is_hidden():
		cursor.show()
