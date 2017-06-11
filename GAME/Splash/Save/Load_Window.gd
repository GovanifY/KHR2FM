extends Panel

# Signals
signal dismiss
signal error
signal finished

# Instance members
onready var anims = get_node("Anims")
onready var Slots = get_node("Slots")

######################
### Core functions ###
######################
func _ready():
	var save_template = Slots.get_node("Save")
	var count = SaveManager.get_save_count()
	for i in range(0, count):
		var node = save_template.duplicate(true)
		var name = "Save " + String(i+1)

		node.set_name(name)
		node.set_text(name)
		node.connect("pressed", self, "_pressed_load", [i])
		# TODO: Populate with KHR2 icons (location + playtime + avatar)

		node.show()
		Slots.add_child(node)

	connect("draw", self, "set_process_input", [true])
	connect("hide", self, "set_process_input", [false])

func _input(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_cancel"):
			emit_signal("dismiss")

#######################
### Signal routines ###
#######################
func _pressed_load(slot_idx):
	var it_loaded = SaveManager.load_game(slot_idx)
	emit_signal("finished" if it_loaded else "error")
