extends Control

# Constants
const ANIM_TIME = 0.35

# Export values
export(String, FILE, "tscn") var next_scene = ""
export(String, FILE, "csv") var csv_path = ""
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
	if Globals.get("Dialogue") == null:
		Globals.set("Dialogue", self)
	Globals.set("Pause", "dialogue")

func _exit_tree():
	if Globals.get("Dialogue") != null:
		Globals.set("Dialogue", null)
	Globals.set("Pause", null)

func _ready():
	# Initializing Translator
	Translator.set_csv(csv_path)

	# Initializing Bubble
	set_alignment(position)

	# Setting potential next scene to be loaded at the end of the Dialogue
	if !next_scene.empty():
		SceneLoader.queue_scene(next_scene)

	# Initializing signals
	Bubble.connect("shown", self, "_get_line")
	CastAnim.connect("tween_complete", self, "_on_CastAnim_complete")

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

func _center_hook():
	var center = current_speaker.get_center()
	if current_speaker.is_flipped():
		center += CastRight.get_pos().x
	Bubble.set_hook(current_speaker, center)

#######################
### Signal routines ###
#######################
func _on_CastAnim_complete(object, key):
	if object.is_type("Avatar"):
		var avatar = object

		if key == "set_opacity":
			# If object's opacity is 0, it's been dismissed
			if avatar.get_opacity() == 0:
				avatar.hide()
				avatar.set_opacity(1.0)

				silence(avatar)

			else: # It's being displayed
				_center_hook()
				if Bubble.is_hidden():
					Bubble.show_box()
				else:
					Bubble.emit_signal("shown")

func _get_line():
	# Parsing lineID
	var lineID = current_speaker.get_name().to_upper() + "_"
	lineID += "%02d" % index
	index += 1

	# Centering hook
	if Bubble.Hook.is_hidden():
		_center_hook()

	write(lineID)

func _next_line():
	if is_loaded(): # Scroll next line
		_get_line()
	else: # No more lines, close everything
		silence()

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
	# Check indexes
	if (end - begin) < 0 || begin < 0:
		print("Dialogue: Invalid indexes.")
		silence(character)
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

# Resets values and silences a given character
func silence(character=current_speaker):
	# Resetting values
	index = -1
	Bubble.Hook.hide()
	set_process_input(false)

	if character != null:
		character.call_deferred("emit_signal", "finished")
		character = null
	emit_signal("finished")

# Hides Bubble box and dismisses all the avatars
func clear():
	silence()
	Bubble.hide_box()

# Displays only ONE Avatar
func display(character):
	var off_bounds = character.Avatar.get_texture().get_size()
	off_bounds.y = 0
	# Drag animation from left or right depending on the situation
	if !character.is_flipped():
		off_bounds.x *= -1

	# Setting character visibility
	character.set_opacity(0)
	character.show()

	CastAnim.interpolate_method(character.Avatar, "set_offset", off_bounds, Vector2(), ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
	CastAnim.interpolate_method(character, "set_opacity", 0.0, 1.0, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)

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
