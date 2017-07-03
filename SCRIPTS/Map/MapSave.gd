extends "MapEvent.gd"

var path_save = "res://SCENES/Pause/SaveMenu.tscn"

func _interacted():
	SceneLoader.load_scene(path_save, SceneLoader.BACKGROUND | SceneLoader.HIGH_PRIORITY)
	SceneLoader.show_scene(path_save)
