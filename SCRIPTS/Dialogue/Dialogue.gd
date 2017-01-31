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

	set_process_input(false)
	emit_signal("finished")

func _hide_avatars():
	var avatars = CastLeft.get_children()
	avatars += CastRight.get_children()
	for av in avatars:
		CastAnim.interpolate_method(av, "set_opacity", 1.0, 0.0, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
	CastAnim.start()

#######################
### Signal routines ###
#######################
func _on_CastAnim_tween_complete(object, key):
	# If the key was about setting offset, it's about speak()
	if key == "set_offset":
		var character = object.get_parent()
		# Centering hook (whenever necessary)
		var center = character.get_center()
		if CastRight.is_a_parent_of(character):
			center += CastRight.get_pos().x
		Bubble.set_hook(character, center)

		if Bubble.is_hidden():
			Bubble.show_box()
		else:
			Bubble.emit_signal("shown")
		return
	# Otherwise, it's about setting opacity
	elif key == "set_opacity":
		object.hide()
		object.set_opacity(1.0)
	emit_signal("finished")

func _get_line():
	# Parsing lineID
	var lineID = ""
	if !current_speaker.get_name().empty():
		lineID += current_speaker.get_name().to_upper() + "_"
	lineID += "%02d" % index

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

	# Necessary checks
	if !is_processing_input():
		set_process_input(true)

# Makes a character speak.
func speak(character, begin, end):
	# Check arguments
	assert(typeof(character) == TYPE_OBJECT && character.is_type("Avatar"))
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
		var off_bounds = character.Avatar.get_texture().get_size()
		off_bounds.y = 0
		if !CastRight.is_a_parent_of(character):
			off_bounds.x *= -1

		# Drag animation from left or right depending on the situation
		CastAnim.interpolate_method(character.Avatar, "set_offset", off_bounds, Vector2(), ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
		CastAnim.start()
		character.show()
	elif !Bubble.Fade.is_playing() || !CastAnim.is_active():
		Bubble.emit_signal("shown")

# Hides Bubble box and dismisses all the avatars
func silence():
	set_process_input(false)
	Bubble.hide_box()
	_hide_avatars()

# Dismisses specified Avatar
func dismiss(character):
	CastAnim.interpolate_method(character, "set_opacity", 1.0, 0.0, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
