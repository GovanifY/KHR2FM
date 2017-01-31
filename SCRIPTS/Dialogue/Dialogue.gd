extends Control

# Constants
const ANIM_TIME = 0.35

# Export values
export(String, FILE, "csv") var csv_path = String()
export(int, "Top", "Middle", "Bottom") var position = 2

# Signals
signal finished

# Instance members
onready var CastLeft  = get_node("CastLeft")
onready var CastRight = get_node("CastRight")
onready var CastAnim  = get_node("CastAnim")
onready var Bubble    = get_node("SkinPos/Bubble")

# "Private" members
var index = -1
var first = 0
var last  = 0
var current_speaker = null

######################
### Core functions ###
######################
func _enter_tree():
	if Globals.get("Dialogue") != null:
		print("One Dialogue node is already enough!")
		queue_free()
	else:
		Globals.set("Dialogue", get_path())

func _exit_tree():
	Globals.set("Dialogue", null)

func _ready():
	# Initializing Translator
	Translator.set_csv(csv_path)

	# Initializing Bubble
	set_alignment(position)

	# Initializing signals
	Bubble.connect("shown", self, "_get_line")
	CastAnim.connect("tween_complete", self, "_on_CastAnim_tween_complete")

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			Bubble.TextScroll.confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.TextScroll.confirm()

	# Touch events
	elif event.type == InputEvent.SCREEN_TOUCH:
		Bubble.TextScroll.confirm()

func _close_dialogue():
	# Resetting values
	index = -1
	current_speaker = null
	Bubble.Hook.hide()

	set_process_input(false)
	emit_signal("finished")

func _center_hook():
	var center = current_speaker.get_center()
	if current_speaker.is_flipped():
		center += CastRight.get_pos().x
	Bubble.set_hook(current_speaker, center)

#######################
### Signal routines ###
#######################
func _on_CastAnim_tween_complete(object, key):
	if key == "set_offset":
		# If object's offset is 0, it's been displayed.
		# FIXME: I have to round this value because Godot is acting like JavaScript
		# and returning me values like -0.000031!!!
		var rounded_offset = round(object.get_offset().x)
		if rounded_offset == 0:
			_center_hook()
			if Bubble.is_hidden():
				Bubble.show_box()
			else:
				Bubble.emit_signal("shown")
	elif key == "set_opacity":
		# If object's opacity is 0, it's been dismissed
		if object.get_opacity() == 0:
			object.hide()
			object.set_opacity(1.0)

			emit_signal("finished")
		# Otherwise, it's being displayed
		else:
			object.show()

func _get_line():
	# Parsing lineID
	var lineID = current_speaker.get_name().to_upper() + "_"
	lineID += "%02d" % index

	# Centering hook
	if Bubble.Hook.is_hidden():
		_center_hook()

	# Incrementing index
	index += 1
	write(lineID)

func _next_line():
	if is_loaded(): # Scroll next line
		_get_line()
	else: # No more lines, close everything
		_close_dialogue()

###############
### Methods ###
###############
# Sets Bubble alignment
func set_alignment(value):
	get_node("SkinPos").set_alignment(value)

# Tells if there are still lines on hold.
func is_loaded():
	return first <= index && index <= last

func set_box(idx):
	Bubble.set_box(idx)

# Writes text on the Dialogue box
func write(text):
	# Writing line to bubble
	Bubble.TextScroll.scroll(text)

	# Enabling input detection
	if !is_processing_input():
		set_process_input(true)

# Makes a character speak.
func speak(character, begin, end=begin):
	# Check arguments
	if (end - begin) < 0:
		print("Dialogue: Invalid indexes.")
		return

	# Setting text iteration values
	index = begin
	first = begin
	last  = end
	current_speaker = character

	# If character's invisible, make grand appearance
	var avatar_texture = character.Avatar.get_texture()
	if character.is_hidden() && avatar_texture != null:
		display(character)
	elif Bubble.is_visible():
		Bubble.emit_signal("shown")

# Hides Bubble box and dismisses all the avatars
func silence():
	set_process_input(false)
	Bubble.hide_box()
	dismiss()

# Displays only ONE Avatar
func display(character):
	var off_bounds = character.Avatar.get_texture().get_size()
	off_bounds.y = 0
	# Drag animation from left or right depending on the situation
	if !character.is_flipped():
		off_bounds.x *= -1

	CastAnim.interpolate_method(character.Avatar, "set_offset", off_bounds, Vector2(), ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
	CastAnim.interpolate_method(character, "set_opacity", 0.0, 1.0, 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN)

	CastAnim.start()

# Dismisses a specified Avatar, or all of them if NULL
func dismiss(character=null):
	var to_dismiss = Array()
	if character != null:
		to_dismiss.push_back(character)
	else:
		to_dismiss = CastLeft.get_children()
		to_dismiss += CastRight.get_children()

	for character in to_dismiss:
		var off_bounds = character.Avatar.get_texture().get_size()
		off_bounds.y = 0
		# Drag animation from left or right depending on the situation
		if !character.is_flipped():
			off_bounds.x *= -1

		CastAnim.interpolate_method(character.Avatar, "set_offset", Vector2(), off_bounds, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
		CastAnim.interpolate_method(character, "set_opacity", 1.0, 0.0, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)

	CastAnim.start()
