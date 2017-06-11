extends Control

# Button index
enum OPTION_CONTROLS { OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT }

# Main Menu instance members
onready var AnimsMenu = get_node("Anims_MM")
onready var Options   = get_node("Options")
onready var Cursor    = get_node("Options/Cursor")
onready var cursor_inc = Cursor.get_texture().get_size() / 4

# Options instance members
onready var NewGame  = get_node("BG_New")
onready var LoadGame = get_node("BG_Load")

######################
### Core functions ###
######################
func _ready():
	# Connecting main options
	for i in range(0, Options.get_child_count()-1):
		var button = Options.get_child(i)
		button.connect("pressed", self, "_pressed_main", [i])
		button.connect("focus_enter", self, "_set_cursor_position", [button])

	# Connecting New Game options
	NewGame.connect("dismiss", NewGame.anims, "play", ["Fade Out"])
	NewGame.connect("finished", self, "_start_new")

	# Connecting New Game options
	LoadGame.connect("dismiss", LoadGame.anims, "play", ["Fade Out"])
	LoadGame.connect("finished", self, "_start_load")

	# Adding music
	AudioRoom.set_stream(preload("res://ASSETS/BGM/Dearly_Beloved.ogg"))
	AudioRoom.play()

	# Waiting few seconds of intro theme entrance
	hide()
	# This is kind of bullshit IMO. I hate unnecessary wait times for menus. - Keyaku
	var timer = get_node("Background/Timer")
	timer.set_one_shot(true)
	timer.set_wait_time(4)
	timer.start()
	yield(timer, "timeout")

	# Presenting Title
	AnimsMenu.play("Background")

#######################
### Signal routines ###
#######################
func _set_cursor_position(button):
	var pos = button.get_pos() + cursor_inc
	Cursor.set_pos(pos)

func _pressed_main(button_idx):
	if button_idx == OPTION_MAIN_NEW:
		NewGame.anims.play("Fade In")

	elif button_idx == OPTION_MAIN_LOAD:
		LoadGame.anims.play("Fade In")

	elif button_idx == OPTION_MAIN_QUIT:
		AnimsMenu.connect("finished", get_tree(), "quit")
		AnimsMenu.play("Close")

func _start_new():
	# Dismiss the window before anything else
	NewGame.anims.play("Fade Out")
	yield(NewGame.anims, "finished")

	# Load Aqua intro at the end of the flashy animation
	AudioRoom.fade_out(1)
	AnimsMenu.connect("finished", SceneLoader, "load_scene", ["res://GAME/STORY/Intro/Aqua.tscn"])
	AnimsMenu.play("New Game")

func _start_load():
	# Dismiss the window before anything else
	LoadGame.anims.play("Fade Out")
	yield(LoadGame.anims, "finished")

	# Load scene now updated in SaveManager
	AudioRoom.fade_out(1)
	AnimsMenu.connect("finished", SceneLoader, "load_scene", [SaveManager.get_scene()])
	AnimsMenu.play("Load Game")
