extends Node2D

var hasbeenset=false
var texttime=false
var textregion=-1

# Really Important Nodes
onready var TextScroll = get_node("/root/TextScroll")
onready var SceneLoader = get_node("/root/SceneLoader")

func _process(delta):
	if texttime==false:
		if !hasbeenset:
			if !get_node("Null1").is_playing():
				#Si le splash est terminé et que les anims ont pas encore été lancées ont les lance.
				get_node("Into_the_darkness").play()
				get_node("Null2").play("Null2")
				hasbeenset=true
		else:
			if !get_node("Null1").is_playing():
				get_node("SE").play("Intro_Message_2")
				get_node("KH_Intro_Anim").play("KH_Intro")
				TextScroll.set_SE(get_node("SE"), "MSG_SOUND")
				texttime=true
	elif texttime==true:
		if !get_node("KH_Intro_Anim").is_playing():
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			texttime=null
			textregion=0
			TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_00"))

	if textregion==0 && !TextScroll.is_active():
		textregion=1
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_01"))
	elif textregion==1 && !TextScroll.is_active():
		textregion=2
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_02"))
	elif textregion==2 && !TextScroll.is_active():
		textregion=3
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_03"))
	elif textregion==3 && !TextScroll.is_active():
		textregion=4
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_04"))
	elif textregion==4 && !TextScroll.is_active():
		textregion=5
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_05"))
	elif textregion==5 && !TextScroll.is_active():
		textregion=6
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_06"))
	elif textregion==6 && !TextScroll.is_active():
		textregion=7
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_07"))
	elif textregion==7 && !TextScroll.is_active():
		textregion=8
		TextScroll.scroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_08"))
	elif textregion==8 && !TextScroll.is_active():
		textregion=9
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("DARKNESS_Intro_Anim").play("DARKNESS_Intro_Anim")
		get_node("BG_Kiryoku_1_Anim").play("BG_Kiryoku_1_Anim")
	elif textregion==9 && !TextScroll.is_active():
		if !get_node("DARKNESS_Intro_Anim").is_playing():
			textregion=10
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_00"))
	elif textregion==10 && !TextScroll.is_active():
		textregion=11
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_01"))
	elif textregion==11 && !TextScroll.is_active():
		textregion=12
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_02"))
	elif textregion==12 && !TextScroll.is_active():
		textregion=13
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_03"))
	elif textregion==13 && !TextScroll.is_active():
		textregion=14
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_04"))
	elif textregion==14 && !TextScroll.is_active():
		get_node("Switch_1").play("Switch_1")
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		textregion=15
	elif textregion==15 && !TextScroll.is_active():
		if !get_node("Switch_1").is_playing():
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_00"))
			textregion=16
	elif textregion==16 && !TextScroll.is_active():
		textregion=17
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_01"))
	elif textregion==17 && !TextScroll.is_active():
		textregion=18
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_02"))
	elif textregion==18 && !TextScroll.is_active():
		textregion=19
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_03"))
	elif textregion==19 && !TextScroll.is_active():
		textregion=20
		get_node("Box_message_002").set_opacity(1)
		get_node("Box_message_002").set_scale(Vector2(1,1))
		get_node("Box_message_002").set_pos(Vector2(0,0))
		get_node("Box_message_000").set_opacity(0)
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_05"))
	elif textregion==20 && !TextScroll.is_active():
		textregion=21
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_06"))
	elif textregion==21 && !TextScroll.is_active():
		textregion=22
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("LIGHT_Intro_Anim").play("LIGHT_Intro_Anim")
	elif textregion==22 && !TextScroll.is_active():
		if get_node("LIGHT_Intro_Anim").get_pos()>10.8:
			get_node("BG_Kiryoku_1_Anim").stop()
			get_node("BG_Kiryoku_2_Anim").play("BG_Kiryoku_2_Anim")
			textregion=23
	elif textregion==23 && !TextScroll.is_active():
		if !get_node("LIGHT_Intro_Anim").is_playing():
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_04"))
			textregion=24
	elif textregion==24 && !TextScroll.is_active():
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_05"))
		textregion=25
	elif textregion==25 && !TextScroll.is_active():
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_06"))
		textregion=26
	elif textregion==26 && !TextScroll.is_active():
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_07"))
		textregion=27
	elif textregion==27 && !TextScroll.is_active():
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_08"))
		textregion=28
	elif textregion==28 && !TextScroll.is_active():
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_09"))
		textregion=29
	elif textregion==29 && !TextScroll.is_active():
		textregion=30
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("KEYBLADE_Intro_Anim").play("KEYBLADE_Intro_Anim")
	elif textregion==30 && !TextScroll.is_active():
		if !get_node("KEYBLADE_Intro_Anim").is_playing():
			textregion=31
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_10"))
	elif textregion==31 && !TextScroll.is_active():
		get_node("Switch_2").play("Switch_2")
		textregion=32
	elif textregion==32 && !TextScroll.is_active():
		if !get_node("Switch_2").is_playing():
			textregion=33
			TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_07"))
	elif textregion==33 && !TextScroll.is_active():
		textregion=34
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_08"))
	elif textregion==34 && !TextScroll.is_active():
		textregion=35
		get_node("Box_message_002").set_opacity(0)
		get_node("Box_message_000").set_opacity(1)
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_11"))
	elif textregion==35 && !TextScroll.is_active():
		textregion=36
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_12"))
	elif textregion==36 && !TextScroll.is_active():
		textregion=37
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_13"))
	elif textregion==37 && !TextScroll.is_active():
		textregion=38
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_14"))
	elif textregion==38 && !TextScroll.is_active():
		textregion=39
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_15"))
	elif textregion==39 && !TextScroll.is_active():
		textregion=40
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_16"))
	elif textregion==40 && !TextScroll.is_active():
		textregion=41
		get_node("Box_message_002").set_opacity(1)
		get_node("Box_message_000").set_opacity(0)
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_09"))
	elif textregion==41 && !TextScroll.is_active():
		textregion=42
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_10"))
	elif textregion==42 && !TextScroll.is_active():
		textregion=43
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_11"))
	elif textregion==43 && !TextScroll.is_active():
		textregion=44
		TextScroll.scroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_12"))
	elif textregion==44 && !TextScroll.is_active():
		textregion=45
		get_node("Box_message_002").set_opacity(0)
		get_node("Box_message_000").set_opacity(1)
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_17"))
	elif textregion==45 && !TextScroll.is_active():
		textregion=46
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_18"))
	elif textregion==46 && !TextScroll.is_active():
		textregion=47
		TextScroll.scroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_19"))
	elif textregion==47 && !TextScroll.is_active():
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("End_Anim").play("End_Anim")
		textregion=48
	elif textregion==48 && !TextScroll.is_active():
		if !get_node("End_Anim").is_playing():
			SceneLoader.goto_scene("res://GAME/SCENES/Game/Intro/Battle_Yuugure.tscn")
func _ready():
	# Initialization here
	set_process(true)
	pass
