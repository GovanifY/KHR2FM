extends Button

# Cancel actions
signal cancel
export(bool) var can_cancel = false

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
	connect("input_event", self, "_play_se")

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

func _play_se(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_cancel") && can_cancel:
			cancel()

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

# KHR2 button methods
func cancel():
	SE.play("system_dismiss")
	emit_signal("cancel")
