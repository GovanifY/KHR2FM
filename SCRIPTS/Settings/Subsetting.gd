extends VBoxContainer

# Signals
signal changed(value)

# Export values
export(String) var controls = ""

# Instance members
onready var name    = get_name().to_lower()
onready var title   = get_node("Subtitle")
onready var control = get_node("Control")
