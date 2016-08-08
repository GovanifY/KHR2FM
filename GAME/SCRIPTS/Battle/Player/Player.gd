extends "res://GAME/SCRIPTS/Battle/Battler.gd"

# Export values
export(int, 1, 20) var player_speed = 5

######################
### Core functions ###
######################
func _ready():
	setup_controls()
	# Player gains control
	play_anim("walk", false)
	set_process_input(true)

func _input(event):
	# Handling Pressed, Non-Repeat
	if event.is_pressed() && !event.is_echo():
		for key in Actions:
			if event.is_action(key):
				action_lock()
				play_anim("action", true)
				#Actions[key].take_event()
				return

	# Simple Input check
	var left  = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var stopped = event.is_action_released("ui_left") || event.is_action_released("ui_right")

	# déterminer la priorité de direction
	if left && right:
		left  = is_facing(true, false)
		right = !left

	# Indiquer la direction finale
	if left || right:
		adjust_facing(left, right)
		Motion = player_speed
		play_anim("walk", true)
	elif stopped && !(left || right):
		Motion = 0
		play_anim("walk", false)

###############
### Methods ###
###############
func setup_controls():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information
		pass
	else:
		var key
		# Adding Guard
		key = "cancel"
		Actions[key] = Battle_Action.new()

		# Adding Attack
		key = "enter"
		#Actions[key] = Battle_Action.new(3)
		#Actions[key].create_timer(self)
