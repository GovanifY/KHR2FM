extends "MapEvent.gd"

var path_save = "res://SCENES/Pause/SaveMenu.tscn"

func _interacted():
	SceneLoader.load_scene(path_save, SceneLoader.BACKGROUND | SceneLoader.HIGH_PRIORITY)
	var scene = SceneLoader.show_scene(path_save)
	scene.get_node("Panel").connect("hide", SceneLoader, "erase_scene", [scene])
