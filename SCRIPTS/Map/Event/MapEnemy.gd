extends "MapEvent.gd"

# Battle scene to load upon touching
export(String, FILE, "tscn") var battle_scene

enum { SPAWN_AREA, BATTLE_AREA }

# Instance members
onready var spawn = get_node("spawn/anim")
onready var Delay = get_node("Delay")

######################
### Core functions ###
######################
func _enter_tree():
	add_to_group("MapEnemy")

func _show():
	if "In" in spawn.get_animation_list():
		spawn.play("In")

func _hide():
	if "Out" in spawn.get_animation_list():
		spawn.play("Out")

######################
### Event routines ###
######################
func _player_touched(area_shape):
	if area_shape == SPAWN_AREA && is_hidden():
		if Delay.get_time_left() > 0:
			return # Don't do anything
		_show()
		Delay.start()

	elif area_shape == BATTLE_AREA && is_visible():
		# TODO: Save exact coordinates of this map before switching scenes
		if battle_scene != null:
			SceneLoader.queue_scene(battle_scene)
			SceneLoader.queue_scene(get_tree().get_current_scene().get_filename())
			SceneLoader.transition("Battle")
			SceneLoader.load_next_scene()

func _player_untouched(area_shape):
	if area_shape == SPAWN_AREA && is_visible():
		if Delay.get_time_left() > 0:
			yield(Delay, "timeout") # Wait until Delay is done
		_hide()
		Delay.start()
