extends Node2D

var hasbeenset=false
var aquaplaying=false

func _process(delta):
	if (hasbeenset == false):
		if(!get_node("Null1").is_playing()):
			#Si le splash est terminé et que les anims ont pas encore été lancées on les lance.
			get_node("Aqua").play()
			hasbeenset=true
			aquaplaying=true
	elif (aquaplaying==true):
		if(!get_node("Aqua").is_playing()):
			get_node("Null2").play("Null2")
			aquaplaying=false
	elif(hasbeenset==true):
		if(!get_node("Null2").is_playing()):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Intro.tscn")
func _ready():
	# Initialization here
	set_process(true)
	#get_node("/root/SceneLoader").preload_scene("res://GAME/SCENES/Game/Intro/Intro.tscn")
	pass