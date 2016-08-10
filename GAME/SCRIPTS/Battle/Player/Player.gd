extends "res://GAME/SCRIPTS/Battle/Battler.gd"

var ComboTimer
var InputActions = {}

######################
### Core functions ###
######################
func _ready():
	# Sets up basic controls
	create_timer()
	setup_controls()
	setup_data()

	# Player gains control
	set_process_input(true)

func _fixed_process(delta):
	if !ActionSet.is_locked():
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
			set_transition(WALK_POSE)
		else:
			set_transition(STILL_POSE)

func _input(event):
	for act in InputActions:
		# Handling Pressed, Non-Repeat
		if event.is_action_pressed(act):
			ActionSet.take(InputActions[act])
			return

###############
### Methods ###
###############
### Overloading functions
func fight():
	.fight()
	set_process_input(true)

func at_ease():
	.at_ease()
	set_process_input(false)

func create_timer():
	if ComboTimer != null:
		ComboTimer.free()

	ComboTimer = Timer.new()
	ComboTimer.set_wait_time(0.4)
	ComboTimer.set_one_shot(true)
	ComboTimer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	add_child(ComboTimer)

func setup_controls():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information
		pass
	else:
		ActionSet = Battle_ActionSet.new(self, STILL_POSE)
		AnimTree.connect("finished", ActionSet, "_end_action")
		ActionSet.set_max_combo(2) # Doesn't count finisher
		ActionSet.attach_timer(ComboTimer)

		# Adding actions
		InputActions["cancel"] = ActionSet.new_action("Guard", false)
		InputActions["enter"] = ActionSet.new_action("Attack")

func setup_data():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information
		pass
