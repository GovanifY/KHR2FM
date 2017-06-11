extends Panel

# Signals
signal error
signal finished

# Instance members
onready var anims  = get_node("Anims")

onready var List   = get_node("List")
onready var Scroll = get_node("List/Scroll")
onready var Slots  = get_node("List/Slots")

onready var Info = {
	"panel" : get_node("Info"),
	"title" : get_node("Info/Title"),
	"msg"   : get_node("Info/Message"),
}

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
		node.connect("focus_enter", self, "_recenter", [node])
		node.connect("pressed", self, "_pressed_load", [i])
		# TODO: Populate with KHR2 icons (location + playtime + avatar)

		node.show()
		Slots.add_child(node)

	connect("draw", self, "_show_up")

#######################
### Signal routines ###
#######################
func _show_up():
	# Initial settings
	Info.panel.hide()

	# Making sure the first Option is selected
	if Slots.get_child_count() > 1:
		Slots.get_child(1).grab_focus()
	else:
		Info.msg.set_text("TITLE_SAVE_NOT_FOUND")
		yield(anims, "finished")
		anims.play("Show Info")

func _recenter(button):
	var y = int(button.get_pos().y)
	Scroll.interpolate_method(
		List, "set_v_scroll", List.get_v_scroll(), y, 0.1,
		Scroll.TRANS_LINEAR, Scroll.EASE_IN
	)
	Scroll.start()

func _pressed_load(slot_idx):
	var it_loaded = SaveManager.load_game(slot_idx)
	emit_signal("finished" if it_loaded else "error")
