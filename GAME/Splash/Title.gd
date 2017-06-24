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
	NewGame.connect("finished", self, "_start_game", ["New Game"])
	LoadGame.connect("finished", self, "_start_game", ["Load Game"])
	LoadGame.anims.connect("animation_started", self, "_on_loadgame_anims")

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
	set_process_input(true)
	AnimsMenu.play("Background")

func _input(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_cancel"):
			_dismiss_menu()

# Finds the appropriate menu to dismiss
func _dismiss_menu():
	for menu in [NewGame, LoadGame]:
		if menu.is_visible() && !menu.anims.is_playing():
			# Reset focus to appropriate button
			for i in range(0, Options.size()-1):
				Options[i].set_focus_mode(FOCUS_ALL)

			# Dismiss menu
			Options[cursor_idx].grab_focus()
			menu.anims.play("Fade Out")
			return

#######################
### Signal routines ###
#######################
func _on_flash_end(name):
	if name != "Flash": return false

	for i in range(0, Options.size()-1):
		Options[i].set_disabled(false)

	# Making sure the first Option is selected
	Options[0].grab_focus()

func _on_loadgame_anims(anim_name):
	if anim_name == "Fade Out":
		SE.play("system_dismiss")

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
	set_process_input(false)

	# Disconnects specific signals
	LoadGame.anims.disconnect("animation_started", self, "_on_loadgame_anims")

	# Dismiss the window before anything else
	var menu = get_node(selection)
	menu.anims.play("Fade Out")
	yield(menu.anims, "finished")

	# Fade music while playing the appropriate animation
	AudioRoom.fade_out(1)
	AnimsMenu.play(selection)
	yield(AnimsMenu, "finished")

	SceneLoader.load_scene(SaveManager.get_scene())
