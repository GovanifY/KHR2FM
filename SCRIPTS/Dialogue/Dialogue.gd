extends Control

# Constants
const ANIM_TIME = 0.35
enum DIALOGUE_TEXT_FX { TEXT_NONE, TEXT_SCROLL }

# Export values
export(String, FILE, "tscn") var next_scene = ""
export(String, FILE, "csv") var csv_path
export(int, "Top", "Middle", "Bottom") var position = 2
export(int, "None", "Scroll") var text_effect = 1

# Signals
signal finished

# Instance members
onready var CastLeft  = get_node("CastLeft")
onready var CastRight = get_node("CastRight")
onready var CastAnim  = get_node("CastAnim")
onready var Bubble    = get_node("SkinPos/Bubble")
onready var TextNode  = Bubble.get_node("TextContainer")

# Text effect nodes
var TextEffect

# "Private" members
var index = -1
var first = 0
var last  = 0
var current_speaker = null

######################
### Core functions ###
######################
func _enter_tree():
	# Initializing Translator
	Translator.set_csv(csv_path)

	# Pause and globalizing this node
	KHR2.set_pause(preload("res://SCENES/Pause/CutscenePause.tscn"))
	if Globals.get("Dialogue") == null:
		Globals.set("Dialogue", self)

func _exit_tree():
	# De-initializing Translator
	Translator.close()

	# Pause and globalizing this node
	KHR2.set_pause(null)
	if Globals.get("Dialogue") != null:
		Globals.set("Dialogue", null)

func _ready():
	# Initializing signals
	CastAnim.connect("tween_complete", self, "_on_CastAnim_complete")
	# Initializing Text effect nodes signals
	TextNode.get_node("TextScroll").connect("cleared", self, "_next_line")

	# Setting Dialogue properties
	set_alignment(position)
	set_text_effect(text_effect)

	# Setting potential next scene to be loaded at the end of the Dialogue
	if !next_scene.empty():
		SceneLoader.queue_scene(next_scene)

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			confirm()

	# Touch events
	elif event.type == InputEvent.SCREEN_TOUCH:
		confirm()

func _center_hook():
	var center = current_speaker.get_center()
	if current_speaker.is_flipped():
		center += CastRight.get_pos().x
	Bubble.set_hook_pos(center)

#######################
### Signal routines ###
#######################
func _on_CastAnim_complete(object, key):
	if object.is_type("Avatar"):
		var avatar = object

		# If object's opacity is 0, it's been dismissed
		if key == "set_opacity" && avatar.get_opacity() == 0:
			avatar.hide()
			avatar.set_opacity(1.0)

func _get_line():
	if current_speaker == null:
		return # No speaker available; random person/narrator talking

	# Parsing lineID
	var lineID = current_speaker.get_name().to_upper() + "_"
	lineID += "%02d" % index
	index += 1

	write(lineID)

func _next_line():
	if is_loaded(): # Scroll next line
		_get_line()
	else: # No more lines, hide Bubble
		silence(current_speaker)

###############
### Methods ###
###############
# Sets Bubble alignment
func set_alignment(value):
	position = value
	get_node("SkinPos").set_alignment(value)

# Sets the text effect to apply when writing. Must be a TextNode child, properly indexed
func set_text_effect(value):
	text_effect = value
	TextEffect = TextNode.get_child(value-1) if value > 0 else null

# Tells if there are still lines on hold.
func is_loaded():
	return first <= index && index <= last

func set_box(idx):
	Bubble.set_box(idx)

# Writes text on the Dialogue box
func write(text):
	# Writing line to textbox
	TextNode.set_visible_characters(0)
	TextNode.set_text(text)

	# Applying text effect
	if text_effect == TEXT_NONE:
		TextNode.set_visible_characters(-1)
	else:
		TextEffect.start()

	# Enabling input detection
	if !is_processing_input():
		set_process_input(true)

# Confirmation from the part of the
func confirm():
	if text_effect == TEXT_NONE:
		call_deferred("_next_line")
	else:
		TextEffect.confirm()

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
	if character.is_hidden() || character.get_opacity() == 0:
		display(character)
		yield(CastAnim, "tween_complete")

	# If Bubble is hidden, show it
	Bubble.set_hook()
	_center_hook()
	if Bubble.is_hidden():
		Bubble.show_box()
		yield(Bubble, "shown")

	# Finally, get the speaker's line
	call_deferred("_get_line")

# Resets values and silences a given character, or hides the box
func silence(character=null):
	current_speaker = null
	if character != null:
		character.call_deferred("emit_signal", "finished")
	else:
		Bubble.hide_box()
		yield(Bubble, "hidden")

	if is_processing_input():
		# Resetting values
		set_process_input(false)
		index = -1
		TextNode.set_visible_characters(0)
		Bubble.set_hook(-1)

		emit_signal("finished")

# Displays only ONE Avatar
func display(character):
	var off_bounds = character.get_off_bounds()

	# Setting character visibility
	character.set_opacity(0)
	character.show()

	CastAnim.interpolate_method(character.sprite, "set_offset", off_bounds, Vector2(), ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
	CastAnim.interpolate_method(character, "set_opacity", 0.0, 1.0, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)

	CastAnim.start()

# Dismisses a specified Avatar, or all of them if NULL
func dismiss(character=null):
	silence(character)

	var to_dismiss = Array()
	if character != null:
		to_dismiss.push_back(character)
	else:
		to_dismiss = CastLeft.get_children()
		to_dismiss += CastRight.get_children()

	for character in to_dismiss:
		var off_bounds = character.get_off_bounds()

		CastAnim.interpolate_method(character.sprite, "set_offset", Vector2(), off_bounds, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
		CastAnim.interpolate_method(character, "set_opacity", 1.0, 0.0, ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)

	CastAnim.start()

# Dismisses all present characters and hides Bubble
func close():
	dismiss()
	if Bubble.is_visible():
		Bubble.hide_box()
		yield(Bubble, "hidden")
	emit_signal("finished")
