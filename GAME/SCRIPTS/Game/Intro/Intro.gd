extends Node2D

var hasbeenset=false

var Dialogue = {
	"started" : false,
	"region" : -1,
	"text" : null
}

# Really Important Nodes
const TextScroll = preload("res://GAME/SCRIPTS/TextScroll.gd")
onready var SceneLoader = get_node("/root/SceneLoader")
onready var AudioRoom = get_node("/root/AudioRoom")

func _process(delta):
	if Dialogue.started==false:
		Dialogue.text = TextScroll.new()
		if !hasbeenset:
			if !get_node("Null1").is_playing():
				#Si le splash est terminé et que les anims ont pas encore été lancées ont les lance.
				AudioRoom.load_music(get_node("Into_the_darkness"))
				AudioRoom.play()
				get_node("Null2").play("Null2")
				hasbeenset=true
		else:
			if !get_node("Null1").is_playing():
				get_node("SE").play("Intro_Message_2")
				get_node("KH_Intro_Anim").play("KH_Intro")
				Dialogue.text.set_SE(get_node("SE"), "MSG_SOUND")
				Dialogue.started=true
	elif Dialogue.started==true:
		if !get_node("KH_Intro_Anim").is_playing():
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			Dialogue.started=null
			Dialogue.region=0
			Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_00"))

	if Dialogue.region==0 && !Dialogue.text.is_active():
		Dialogue.region=1
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_01"))
	elif Dialogue.region==1 && !Dialogue.text.is_active():
		Dialogue.region=2
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_02"))
	elif Dialogue.region==2 && !Dialogue.text.is_active():
		Dialogue.region=3
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_03"))
	elif Dialogue.region==3 && !Dialogue.text.is_active():
		Dialogue.region=4
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_04"))
	elif Dialogue.region==4 && !Dialogue.text.is_active():
		Dialogue.region=5
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_05"))
	elif Dialogue.region==5 && !Dialogue.text.is_active():
		Dialogue.region=6
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_06"))
	elif Dialogue.region==6 && !Dialogue.text.is_active():
		Dialogue.region=7
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_07"))
	elif Dialogue.region==7 && !Dialogue.text.is_active():
		Dialogue.region=8
		Dialogue.text.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_08"))
	elif Dialogue.region==8 && !Dialogue.text.is_active():
		Dialogue.region=9
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("DARKNESS_Intro_Anim").play("DARKNESS_Intro_Anim")
		get_node("BG_Kiryoku_1_Anim").play("BG_Kiryoku_1_Anim")
	elif Dialogue.region==9 && !Dialogue.text.is_active():
		if !get_node("DARKNESS_Intro_Anim").is_playing():
			Dialogue.region=10
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_00"))
	elif Dialogue.region==10 && !Dialogue.text.is_active():
		Dialogue.region=11
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_01"))
	elif Dialogue.region==11 && !Dialogue.text.is_active():
		Dialogue.region=12
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_02"))
	elif Dialogue.region==12 && !Dialogue.text.is_active():
		Dialogue.region=13
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_03"))
	elif Dialogue.region==13 && !Dialogue.text.is_active():
		Dialogue.region=14
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_04"))
	elif Dialogue.region==14 && !Dialogue.text.is_active():
		get_node("Switch_1").play("Switch_1")
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		Dialogue.region=15
	elif Dialogue.region==15 && !Dialogue.text.is_active():
		if !get_node("Switch_1").is_playing():
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_00"))
			Dialogue.region=16
	elif Dialogue.region==16 && !Dialogue.text.is_active():
		Dialogue.region=17
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_01"))
	elif Dialogue.region==17 && !Dialogue.text.is_active():
		Dialogue.region=18
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_02"))
	elif Dialogue.region==18 && !Dialogue.text.is_active():
		Dialogue.region=19
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_03"))
	elif Dialogue.region==19 && !Dialogue.text.is_active():
		Dialogue.region=20
		get_node("Box_message_002").set_opacity(1)
		get_node("Box_message_002").set_scale(Vector2(1,1))
		get_node("Box_message_002").set_pos(Vector2(0,0))
		get_node("Box_message_000").set_opacity(0)
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_05"))
	elif Dialogue.region==20 && !Dialogue.text.is_active():
		Dialogue.region=21
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_06"))
	elif Dialogue.region==21 && !Dialogue.text.is_active():
		Dialogue.region=22
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("LIGHT_Intro_Anim").play("LIGHT_Intro_Anim")
	elif Dialogue.region==22 && !Dialogue.text.is_active():
		if get_node("LIGHT_Intro_Anim").get_pos()>10.8:
			get_node("BG_Kiryoku_1_Anim").stop()
			get_node("BG_Kiryoku_2_Anim").play("BG_Kiryoku_2_Anim")
			Dialogue.region=23
	elif Dialogue.region==23 && !Dialogue.text.is_active():
		if !get_node("LIGHT_Intro_Anim").is_playing():
			AudioRoom.stop()
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_04"))
			Dialogue.region=24
	elif Dialogue.region==24 && !Dialogue.text.is_active():
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_05"))
		Dialogue.region=25
	elif Dialogue.region==25 && !Dialogue.text.is_active():
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_06"))
		Dialogue.region=26
	elif Dialogue.region==26 && !Dialogue.text.is_active():
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_07"))
		Dialogue.region=27
	elif Dialogue.region==27 && !Dialogue.text.is_active():
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_08"))
		Dialogue.region=28
	elif Dialogue.region==28 && !Dialogue.text.is_active():
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_09"))
		Dialogue.region=29
	elif Dialogue.region==29 && !Dialogue.text.is_active():
		Dialogue.region=30
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("KEYBLADE_Intro_Anim").play("KEYBLADE_Intro_Anim")
	elif Dialogue.region==30 && !Dialogue.text.is_active():
		if !get_node("KEYBLADE_Intro_Anim").is_playing():
			Dialogue.region=31
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_10"))
	elif Dialogue.region==31 && !Dialogue.text.is_active():
		get_node("Switch_2").play("Switch_2")
		Dialogue.region=32
	elif Dialogue.region==32 && !Dialogue.text.is_active():
		if !get_node("Switch_2").is_playing():
			Dialogue.region=33
			Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_07"))
	elif Dialogue.region==33 && !Dialogue.text.is_active():
		Dialogue.region=34
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_08"))
	elif Dialogue.region==34 && !Dialogue.text.is_active():
		Dialogue.region=35
		get_node("Box_message_002").set_opacity(0)
		get_node("Box_message_000").set_opacity(1)
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_11"))
	elif Dialogue.region==35 && !Dialogue.text.is_active():
		Dialogue.region=36
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_12"))
	elif Dialogue.region==36 && !Dialogue.text.is_active():
		Dialogue.region=37
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_13"))
	elif Dialogue.region==37 && !Dialogue.text.is_active():
		Dialogue.region=38
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_14"))
	elif Dialogue.region==38 && !Dialogue.text.is_active():
		Dialogue.region=39
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_15"))
	elif Dialogue.region==39 && !Dialogue.text.is_active():
		Dialogue.region=40
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_16"))
	elif Dialogue.region==40 && !Dialogue.text.is_active():
		Dialogue.region=41
		get_node("Box_message_002").set_opacity(1)
		get_node("Box_message_000").set_opacity(0)
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_09"))
	elif Dialogue.region==41 && !Dialogue.text.is_active():
		Dialogue.region=42
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_10"))
	elif Dialogue.region==42 && !Dialogue.text.is_active():
		Dialogue.region=43
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_11"))
	elif Dialogue.region==43 && !Dialogue.text.is_active():
		Dialogue.region=44
		Dialogue.text.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_12"))
	elif Dialogue.region==44 && !Dialogue.text.is_active():
		Dialogue.region=45
		get_node("Box_message_002").set_opacity(0)
		get_node("Box_message_000").set_opacity(1)
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_17"))
	elif Dialogue.region==45 && !Dialogue.text.is_active():
		Dialogue.region=46
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_18"))
	elif Dialogue.region==46 && !Dialogue.text.is_active():
		Dialogue.region=47
		Dialogue.text.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_19"))
	elif Dialogue.region==47 && !Dialogue.text.is_active():
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("End_Anim").play("End_Anim")
		AudioRoom.load_music(get_node("The_Eye_of_Darkness"))
		AudioRoom.play()
		Dialogue.region=48
	elif Dialogue.region==48 && !Dialogue.text.is_active():
		if !get_node("End_Anim").is_playing():
			Dialogue.text.free()
			Dialogue.text = null
			SceneLoader.add_scene("Game/Intro/Battle_Yuugure.tscn")
			SceneLoader.load_new_scene()
			return

	# Update text
	if Dialogue.text != null && Dialogue.text.is_active():
		Dialogue.text.update_text()

func _ready():
	set_process(true)
	pass
