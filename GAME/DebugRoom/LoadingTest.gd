extends Node

# Instance members
onready var Message = get_node("Message")

######################
### Core functions ###
######################
func _ready():
	get_node("Options").connect("button_selected", self, "_on_button_press")

func _on_button_press(button_idx):
	# 1. Test background loading, then erasing it
	# 2. Same as 1., but show it on top of the current scene
	# 3. Same as 1., but halt the current scene
	# 4. Test foreground loading (uses loading screen)

	var method = "t" + String(button_idx)
	Message.set_text("Called " + method)
	call(method)

######################
### Test functions ###
######################
func t0():
	var path = "DebugRoom/DialogueTest.tscn"
	SceneLoader.load_scene(path, true)
	SceneLoader.erase_scene(path)

func t1():
	var path = "DebugRoom/DialogueTest.tscn"
	SceneLoader.load_scene(path, true)
	SceneLoader.show_scene(path)

func t2():
	var path = "DebugRoom/BattleTest.tscn"
	SceneLoader.load_scene(path, true)
	SceneLoader.show_scene(path, true)

func t3():
	var path = "DebugRoom/DialogueTest.tscn"
	SceneLoader.load_scene(path, false)
