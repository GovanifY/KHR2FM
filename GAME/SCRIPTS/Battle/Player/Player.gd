extends "res://GAME/SCRIPTS/Battle/Battler.gd"

# Export values
export(int, 1, 20) var player_speed = 5

var ComboTimer

######################
### Core functions ###
######################
func _ready():
	# Sets up basic controls
	create_timer()
	setup_controls()

	# Player gains control
	set_transition("walk", false)
	set_process_input(true)

func _input(event):
	# Handling Pressed, Non-Repeat
	if event.is_pressed() && !event.is_echo():
		for act in Actions:
			if event.is_action(act):
				Actions[act].take()
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
		set_transition("walk", true)
	elif stopped && !(left || right):
		Motion = 0
		set_transition("walk", false)

###############
### Methods ###
###############
func create_timer():
	if ComboTimer != null:
		ComboTimer.free()

	ComboTimer = Timer.new()
	ComboTimer.set_wait_time(0.3)
	ComboTimer.set_one_shot(true)
	ComboTimer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	add_child(ComboTimer)

func setup_controls():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information
		pass
	else:
		var key
		# Adding Guard
		key = "cancel"
		Actions[key] = Battle_Action.new(self, false)

		# Adding Attack
		key = "enter"
		Actions[key] = Battle_Action.new(self, true, 3)
		Actions[key].attach_timer(ComboTimer)
