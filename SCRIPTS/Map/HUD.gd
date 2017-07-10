extends Control

# Preset commands
const DEFAULT = "MAP_GENERAL_INTERACT"
const COMMAND = {
	"NPC"       : "MAP_GENERAL_TALK",
	"SavePoint" : "MAP_GENERAL_SAVE",
}

# Instance members
onready var interact = get_node("Interact")

func _ready():
	var player = Globals.get("MapPlayer")

	# General settings
	for command in get_children():
		command.hide()
		if player != null:
			command.connect("input_event", player, "interact")

func set_command(node, key):
	if COMMAND.has(key):
		node.set_text(COMMAND[key])
	else:
		node.set_text(DEFAULT)
