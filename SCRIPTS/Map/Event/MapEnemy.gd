extends "MapEvent.gd"

# Battle scene to load upon touching
export(String, FILE, "tscn") var battle_scene

enum { SPAWN_AREA, BATTLE_AREA }

# Instance members
onready var spawn = get_node("spawn/anim")

######################
### Core functions ###
######################
func _ready():
	add_to_group("MapEnemy")
	hide()

func _draw():
	if "In" in spawn.get_animation_list():
		spawn.play("In")

func _hide():
	if "Out" in spawn.get_animation_list():
		spawn.play("Out")
		yield(spawn, "finished")
		hide()

######################
### Event routines ###
######################
func _player_touched(area_shape):
	if area_shape == SPAWN_AREA:
		show()
	elif area_shape == BATTLE_AREA:
		# TODO: Save exact coordinates of this map before switching scenes
		if battle_scene != null:
			SceneLoader.queue_scene(battle_scene)
			SceneLoader.queue_scene(get_tree().get_current_scene().get_filename())
			SceneLoader.transition("Battle")
			SceneLoader.load_next_scene()

func _player_untouched(area_shape):
	if area_shape == SPAWN_AREA:
		_hide()
