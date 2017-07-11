extends "MapEvent.gd"

export(String, FILE, "tscn") var battle_scene

func _player_touched():
	# TODO: Save exact coordinates of this map before switching scenes
	# TODO: Play introductory animation (the heart explosion thing)
	SceneLoader.queue_scene(battle_scene)
	SceneLoader.queue_scene(get_tree().get_current_scene().get_filename())
	SceneLoader.load_next_scene()
