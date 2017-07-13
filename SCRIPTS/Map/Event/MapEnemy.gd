extends "MapEvent.gd"

# Battle scene to load upon touching
export(String, FILE, "tscn") var battle_scene

# Instance members
onready var spawn = get_node("spawn/anim")

func _ready():
	if "In" in spawn.get_animation_list():
		spawn.play("In")

func _player_touched():
	# TODO: Save exact coordinates of this map before switching scenes
	if battle_scene != null:
		SceneLoader.queue_scene(battle_scene)
		SceneLoader.queue_scene(get_tree().get_current_scene().get_filename())
		SceneLoader.transition("Battle")
		SceneLoader.load_next_scene()

func queue_free():
	if "Out" in spawn.get_animation_list():
		spawn.play("Out")
		yield(spawn, "finished")

	.queue_free()
