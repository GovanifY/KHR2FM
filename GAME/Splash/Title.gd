extends Control


# Button index
enum OPTION_CONTROLS { OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT }

# Main Menu instance members
onready var AnimsMenu = get_node("Anims_MM")
onready var Options   = get_node("Options").get_children()
var cursor_idx = 0

# Options instance members
onready var NewGame  = get_node("New Game")
onready var LoadGame = get_node("Load Game")

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

	# Making specific connections
	NewGame.connect("hide", self, "_dismissed_menu")
	NewGame.connect("finished", self, "_start_game", ["New Game"])
	LoadGame.connect("hide", self, "_dismissed_menu")
	LoadGame.connect("finished", self, "_start_game", ["Load Game"])

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
	Options[button_idx].release_focus()
	for i in range(0, Options.size()-1):
		Options[i].set_focus_mode(FOCUS_NONE)

	# Specific rules
	if button_idx == OPTION_MAIN_NEW:
		NewGame.anims.play("Fade In")

	elif button_idx == OPTION_MAIN_LOAD:
		LoadGame.anims.play("Fade In")

	elif button_idx == OPTION_MAIN_QUIT:
		for i in range(0, Options.size()-1):
			Options[i].set_disabled(true)

		AudioRoom.fade_out(1)
		AnimsMenu.connect("finished", get_tree(), "quit")
		AnimsMenu.play("Close")

func _start_game(selection):
	# Disconnects specific signals
	NewGame.disconnect("hide", self, "_dismissed_menu")
	LoadGame.disconnect("hide", self, "_dismissed_menu")

	# Dismiss the window before anything else
	var menu = get_node(selection)
	menu.anims.play("Fade Out")
	yield(menu.anims, "finished")

	# Fade music while playing the appropriate animation
	AudioRoom.fade_out(1)
	AnimsMenu.play(selection)
	yield(AnimsMenu, "finished")

	SceneLoader.load_scene(SaveManager.get_scene())
