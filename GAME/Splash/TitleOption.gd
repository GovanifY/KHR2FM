extends "res://SCRIPTS/Button/KHR2_Button.gd"

const TITLE_BUTTON_NORMAL   = preload("res://ASSETS/GFX/Title/MainMenu/TitleOption_icon_normal.png")
const TITLE_BUTTON_SELECTED = preload("res://ASSETS/GFX/Title/MainMenu/TitleOption_icon_selected.png")

func _ready():
	connect("focus_enter", self, "set_button_icon", [TITLE_BUTTON_SELECTED])
	connect("focus_exit", self, "set_button_icon", [TITLE_BUTTON_NORMAL])
