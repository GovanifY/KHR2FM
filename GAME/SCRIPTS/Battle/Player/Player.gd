extends "res://GAME/SCRIPTS/Battle/Battler.gd"

var InputActions = {}

######################
### Core functions ###
######################
func _ready():
	create_timer(0.4, true)
	# Sets up basic controls
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

func setup_controls():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information
		pass
	else:
		ActionSet = Battle_ActionSet.new(self, STILL_POSE)
		AnimTree.connect("finished", ActionSet, "_end_action")
		ActionSet.attach_timer(Data.timer)
		ActionSet.set_max_combo(2) # Doesn't count finisher

		# Adding actions
		InputActions["cancel"] = ActionSet.new_action("Guard", false)
		InputActions["enter"] = ActionSet.new_action("Attack")

func setup_data():
	if Globals.get("PlayerData"):
		# TODO: Grab PlayerData's battler information
		pass
