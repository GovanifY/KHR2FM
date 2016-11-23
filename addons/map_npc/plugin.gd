tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("MapNPC", "StaticBody2D", preload("MapNPC.gd"), preload("icon.png"))

func _exit_tree():
	remove_custom_type("MapNPC")
