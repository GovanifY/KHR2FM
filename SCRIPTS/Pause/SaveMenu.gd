extends "LoadMenu.gd"

var BinaryChoice = preload("res://SCENES/Button/BinaryChoice.tscn").instance()

######################
### Core functions ###
######################
func _ready():
	connect("finished", self, "_refresh")

	# Adding Yes/No buttons
	Info.content.add_child(BinaryChoice)

#######################
### Signal routines ###
#######################
# When this window is shown
func _show():
	BinaryChoice.hide()

	# Adding "New save" slot before loading all the others
	var new_save = List.new_slot(self, "_pressed")

	new_save.set_name("-1")
	new_save.set_text("New Save")
	List.edit_slot(new_save, null)

	List.set_disabled_slots(false)

	._show()

func _refresh():
	List.cleanup()
	_show()

func _pressed(button):
	# Assuming initial settings
	BinaryChoice.hide()
	List.set_disabled_slots(true)
	if !SaveManager.is_connected("saved", self, "_done"):
		SaveManager.connect("saved", self, "_done")

	var slot_idx = int(button.get_name())
	var pressed_yes = true

	# Find the appropriate slot_idx
	if slot_idx < 0:
		slot_idx = SaveManager.find_available_slot()
	else:
		# Show confirmation buttons and select "No"
		BinaryChoice.show()
		BinaryChoice.no.grab_focus()

		# Show info panel
		set_info_size(INFO_SIZE_MEDIUM)
		show_info("MENU_SAVE_CONFIRM", "Confirm")
		yield(anims, "finished")

		# Wait for confirmation button press
		pressed_yes = yield(BinaryChoice, "pressed")

	if pressed_yes:
		BinaryChoice.hide()
		set_info_size(INFO_SIZE_SMALL)
		show_info("MENU_SAVE_WAIT")
		SaveManager.save_game(slot_idx)
	else:
		List.set_disabled_slots(false)
		hide_info()
		yield(anims, "finished")
		button.grab_focus()
