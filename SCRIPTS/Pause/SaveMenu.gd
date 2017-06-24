extends "LoadMenu.gd"

######################
### Core functions ###
######################
func _ready():
	connect("finished", self, "_refresh")

#######################
### Signal routines ###
#######################
# When this window is shown
func _show():
	# Adding "New save" slot before loading all the others
	var new_save = List.new_slot(self, "_pressed")
	new_save.set_name("-1")
	._show()

func _refresh():
	List.cleanup()
	_show()

func _pressed(button):
	var slot_idx = int(button.get_name())

	# Find the appropriate slot_idx
	if slot_idx < 0:
		slot_idx = SaveManager.find_available_slot()
	else:
		return # FIXME: Remove this
		show_info("MENU_SAVE_CONFIRM")
		yield(anims, "finished")

		return # TODO: Ask player for confirmation

	SaveManager.connect("saved", self, "_done")

	show_info("MENU_SAVE_WAIT")
	SaveManager.save_game(slot_idx)
