extends Control

# Constants
const ANIM_TIME = 0.35

# Export values
export(String, FILE, "csv") var csv_path = String()
export(int, "Top", "Middle", "Bottom") var position = 2
export(Sample) var confirm_sound = preload("res://ASSETS/SE/System/MSG_SOUND.wav")
export(Sample) var character_sound

# Signals
signal finished

# Instance members
onready var SE_node   = get_node("SE")
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
func _ready():
	# Initializing Translator
	Translator.set_csv(csv_path)

	# Initializing Bubble
	set_alignment(position)

	# Initializing sound
	if confirm_sound != null:
		SE_node.get_sample_library().add_sample("Confirm", confirm_sound)
	if character_sound != null:
		SE_node.get_sample_library().add_sample("Character", character_sound)
		Bubble.TextScroll.set_sound_node(SE_node)

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
		if Bubble.is_hidden():
			Bubble.show_box()
		else:
			Bubble.emit_signal("shown")
	# Otherwise, it's about _hide_avatars()

func _get_line():
	# Parsing lineID
	var lineID = ""
	if !current_speaker.get_name().empty():
		lineID += current_speaker.get_name().to_upper() + "_"
	lineID += "%02d" % index

	# Incrementing index
	index += 1

	# Writing line to bubble
	Bubble.TextScroll.scroll(lineID)

	# Necessary checks
	if !is_processing_input():
		set_process_input(true)

func _next_line():
	if confirm_sound != null:
		SE_node.play("Confirm")

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

# Makes a character speak.
func speak(character, begin, end, right = false):
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

	# if this character is actually a "character", then rearrange the scenery for it
	if Bubble.get_box() == 0:
		# Fitting avatars in the Dialogue window
		if is_a_parent_of(character):
			remove_child(character)
			if right:
				CastRight.add_child(character)
			else:
				CastLeft.add_child(character)

		# Positioning the hook
		var center = character.get_center()
		if right:
			center += CastRight.get_pos().x
		Bubble.set_hook_pos(center)

		# Flipping the character's sprite
		character.set_flip_h(right)
		# If character's invisible, make grand appearance
		var avatar_texture = character.Avatar.get_texture()
		if character.is_hidden() && avatar_texture != null:
			var off_bounds = character.Avatar.get_texture().get_size()
			off_bounds.y = 0
			if !right:
				off_bounds.x *= -1

			CastAnim.interpolate_method(character.Avatar, "set_offset", off_bounds, Vector2(), ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
			CastAnim.start()
			character.show()

	else:
		Bubble.show_box()


# Hides Bubble box and dismisses all the avatars
func silence():
	set_process_input(false)
	Bubble.hide_box()
	_hide_avatars()
