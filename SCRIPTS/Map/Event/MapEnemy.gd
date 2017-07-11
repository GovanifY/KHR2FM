extends "MapEvent.gd"

export(String, FILE, "tscn") var battle_scene

func _player_touched():
	# TODO: Save exact coordinates of this map before switching scenes
	# TODO: Play introductory animation (the heart explosion thing)
	SceneLoader.load_scene(battle_scene)
