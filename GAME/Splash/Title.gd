extends Control


# Button index
enum OPTION_CONTROLS { OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT }

# Main Menu instance members
onready var AnimsMenu = get_node("Anims_MM")
onready var Options   = get_node("Options").get_children()
onready var Menu      = [
	get_node("New Game"),
	get_node("Load Game"),
]
var cursor_idx = 0

######################
### Core functions ###
######################
func _ready():
	# Making sure all buttons are available only at the end of the animation
	AnimsMenu.connect("animation_started", self, "_on_flash_end")

	# Connecting main options
	for i in range(0, Options.size()-1):
		var button = Options[i]
		button.set_disabled(true)
		button.connect("pressed", self, "_pressed_main", [i])
		if i < Menu.size():
			Menu[i].connect("hide", self, "_dismissed_menu")

	# Making specific connections
	Menu[0].connect("finished", self, "_start_game", ["New Game"])
	Menu[1].connect("finished", self, "_start_game", ["Load Game"])

	# Adding music
	AudioRoom.set_stream(preload("res://ASSETS/BGM/Dearly_Beloved.ogg"))
	AudioRoom.play()

	# Waiting few seconds of intro theme entrance
	hide()
	# This is kind of bullshit IMO. I hate unnecessary wait times for menus. - Keyaku
	var timer = get_node("Background/Timer")
	timer.start()
	yield(timer, "timeout")

	# Presenting Title
	AnimsMenu.play("Background")

#######################
### Signal routines ###
#######################
func _on_flash_end(name):
	if name != "Flash": return false

	for i in range(0, Options.size()-1):
		Options[i].set_disabled(false)

	# Making sure the first Option is selected
	Options[0].grab_focus()

# Behaves upon given menu dismissal
func _dismissed_menu():
	# Reset focus to appropriate button
	for i in range(0, Options.size()-1):
		Options[i].set_focus_mode(FOCUS_ALL)
	Options[cursor_idx].grab_focus()

func _pressed_main(button_idx):
	cursor_idx = button_idx

	# General rules
	for i in range(0, Options.size()-1):
		Options[i].set_focus_mode(FOCUS_NONE)

	# Specific rules
	if button_idx in [OPTION_MAIN_NEW, OPTION_MAIN_LOAD] && Menu[button_idx].is_hidden():
		Menu[button_idx].anims.play("Fade In")

	elif button_idx == OPTION_MAIN_QUIT:
		for i in range(0, Options.size()-1):
			Options[i].set_disabled(true)

		AudioRoom.fade_out(1)
		AnimsMenu.connect("finished", get_tree(), "quit")
		AnimsMenu.play("Close")

func _start_game(selection):
	# Disconnects specific signals
	for i in range(0, Menu.size()):
		Menu[i].disconnect("hide", self, "_dismissed_menu")

	# Dismiss the window before anything else
	var menu = get_node(selection)
	menu.anims.play("Fade Out")
	yield(menu.anims, "finished")

	# Fade music while playing the appropriate animation
	AudioRoom.fade_out(1)
	AnimsMenu.play(selection)
	yield(AnimsMenu, "finished")

	SceneLoader.load_scene(SaveManager.get_scene())
