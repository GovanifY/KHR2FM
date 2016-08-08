extends "res://GAME/SCRIPTS/Battle/Battler.gd"

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

func _fixed_process(delta):
	# Simple Input check
	var left  = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")

	# déterminer la priorité de direction
	if left && right:
		left  = is_facing(true, false)
		right = !left

	# Indiquer la direction finale
	if left || right:
		adjust_facing(left, right)
		move_x()
		set_transition("walk", true)
	else:
		set_transition("walk", false)

func _input(event):
	# Handling Pressed, Non-Repeat
	if event.is_pressed() && !event.is_echo():
		for act in Actions:
			if event.is_action(act):
				Actions[act].take()
				return

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
