extends Node2D

var hasbeenset=false
var texttime=false
var textregion=0

func _process(delta):
	if (hasbeenset==false):
		if(!get_node("Null1").is_playing()):
			#Si le splash est terminé et que les anims ont pas encore été lancées ont les lance.
			get_node("Into_the_darkness").play()
			get_node("Null2").play("Null2")
			hasbeenset=true
	elif(hasbeenset==true):
		if(!get_node("Null1").is_playing()):
			get_node("SE").play("Intro_Message_2")
			get_node("KH_Intro_Anim").play("KH_Intro")
			hasbeenset=null
			texttime=true
	elif(texttime==true):
		if(!get_node("KH_Intro_Anim").is_playing()):
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			texttime=false
			get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_00"), get_node("SE"), "MSG_SOUND")
	elif(textregion==0 && !Globals.get("TextScrolling")):
		textregion=1
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_01"), get_node("SE"), "MSG_SOUND")
	elif(textregion==1 && !Globals.get("TextScrolling")):
		textregion=2
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_02"), get_node("SE"), "MSG_SOUND")
	elif(textregion==2 && !Globals.get("TextScrolling")):
		textregion=3
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_03"), get_node("SE"), "MSG_SOUND")
	elif(textregion==3 && !Globals.get("TextScrolling")):
		textregion=4
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_04"), get_node("SE"), "MSG_SOUND")
	elif(textregion==4 && !Globals.get("TextScrolling")):
		textregion=5
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_05"), get_node("SE"), "MSG_SOUND")
	elif(textregion==5 && !Globals.get("TextScrolling")):
		textregion=6
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_06"), get_node("SE"), "MSG_SOUND")
	elif(textregion==6 && !Globals.get("TextScrolling")):
		textregion=7
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_07"), get_node("SE"), "MSG_SOUND")
	elif(textregion==7 && !Globals.get("TextScrolling")):
		textregion=8
		get_node("/root/global").textscroll(get_node("Narrator_Messages"), tr("INTRO_TEXT_08"), get_node("SE"), "MSG_SOUND")
	elif(textregion==8 && !Globals.get("TextScrolling")):
		textregion=9
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("DARKNESS_Intro_Anim").play("DARKNESS_Intro_Anim")
		get_node("BG_Kiryoku_1_Anim").play("BG_Kiryoku_1_Anim")
	elif(textregion==9 && !Globals.get("TextScrolling")):
		if(!get_node("DARKNESS_Intro_Anim").is_playing()):
			textregion=10
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_00"), get_node("SE"), "MSG_SOUND")
	elif(textregion==10 && !Globals.get("TextScrolling")):
		textregion=11
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_01"), get_node("SE"), "MSG_SOUND")
	elif(textregion==11 && !Globals.get("TextScrolling")):
		textregion=12
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_02"), get_node("SE"), "MSG_SOUND")
	elif(textregion==12 && !Globals.get("TextScrolling")):
		textregion=13
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_03"), get_node("SE"), "MSG_SOUND")
	elif(textregion==13 && !Globals.get("TextScrolling")):
		textregion=14
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_04"), get_node("SE"), "MSG_SOUND")
	elif(textregion==14 && !Globals.get("TextScrolling")):
		get_node("Switch_1").play("Switch_1")
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		textregion=15
	elif(textregion==15 && !Globals.get("TextScrolling")):
		if(!get_node("Switch_1").is_playing()):
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_00"), get_node("SE"), "MSG_SOUND")
			textregion=16
	elif(textregion==16 && !Globals.get("TextScrolling")):
		textregion=17
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_01"), get_node("SE"), "MSG_SOUND")
	elif(textregion==17 && !Globals.get("TextScrolling")):
		textregion=18
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_02"), get_node("SE"), "MSG_SOUND")
	elif(textregion==18 && !Globals.get("TextScrolling")):
		textregion=19
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_03"), get_node("SE"), "MSG_SOUND")
	elif(textregion==19 && !Globals.get("TextScrolling")):
		textregion=20
		get_node("Box_message_002").set_opacity(1)
		get_node("Box_message_002").set_scale(Vector2(1,1))
		get_node("Box_message_002").set_pos(Vector2(0,0))
		get_node("Box_message_000").set_opacity(0)
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_05"), get_node("SE"), "MSG_SOUND")
	elif(textregion==20 && !Globals.get("TextScrolling")):
		textregion=21
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_06"), get_node("SE"), "MSG_SOUND")
	elif(textregion==21 && !Globals.get("TextScrolling")):
		textregion=22
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("LIGHT_Intro_Anim").play("LIGHT_Intro_Anim")
	elif(textregion==22 && !Globals.get("TextScrolling")):
		if(get_node("LIGHT_Intro_Anim").get_pos()>10.8):
			get_node("BG_Kiryoku_1_Anim").stop()
			get_node("BG_Kiryoku_2_Anim").play("BG_Kiryoku_2_Anim")
			textregion=23
	elif(textregion==23 && !Globals.get("TextScrolling")):
		if(!get_node("LIGHT_Intro_Anim").is_playing()):
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_04"), get_node("SE"), "MSG_SOUND")
			textregion=24
	elif(textregion==24 && !Globals.get("TextScrolling")):
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_05"), get_node("SE"), "MSG_SOUND")
		textregion=25
	elif(textregion==25 && !Globals.get("TextScrolling")):
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_06"), get_node("SE"), "MSG_SOUND")
		textregion=26
	elif(textregion==26 && !Globals.get("TextScrolling")):
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_07"), get_node("SE"), "MSG_SOUND")
		textregion=27
	elif(textregion==27 && !Globals.get("TextScrolling")):
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_08"), get_node("SE"), "MSG_SOUND")
		textregion=28
	elif(textregion==28 && !Globals.get("TextScrolling")):
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_09"), get_node("SE"), "MSG_SOUND")
		textregion=29
	elif(textregion==29 && !Globals.get("TextScrolling")):
		textregion=30
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("KEYBLADE_Intro_Anim").play("KEYBLADE_Intro_Anim")
	elif(textregion==30 && !Globals.get("TextScrolling")):
		if(!get_node("KEYBLADE_Intro_Anim").is_playing()):
			textregion=31
			get_node("Keyblade_Anim").play("Keyblade_Anim")
			get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_10"), get_node("SE"), "MSG_SOUND")
	elif(textregion==31 && !Globals.get("TextScrolling")):
		get_node("Switch_2").play("Switch_2")
		textregion=32
	elif(textregion==32 && !Globals.get("TextScrolling")):
		if(!get_node("Switch_2").is_playing()):
			textregion=33
			get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_07"), get_node("SE"), "MSG_SOUND")
	elif(textregion==33 && !Globals.get("TextScrolling")):
		textregion=34
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_08"), get_node("SE"), "MSG_SOUND")
	elif(textregion==34 && !Globals.get("TextScrolling")):
		textregion=35
		get_node("Box_message_002").set_opacity(0)
		get_node("Box_message_000").set_opacity(1)
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_11"), get_node("SE"), "MSG_SOUND")
	elif(textregion==35 && !Globals.get("TextScrolling")):
		textregion=36
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_12"), get_node("SE"), "MSG_SOUND")
	elif(textregion==36 && !Globals.get("TextScrolling")):
		textregion=37
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_13"), get_node("SE"), "MSG_SOUND")
	elif(textregion==37 && !Globals.get("TextScrolling")):
		textregion=38
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_14"), get_node("SE"), "MSG_SOUND")
	elif(textregion==38 && !Globals.get("TextScrolling")):
		textregion=39
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_15"), get_node("SE"), "MSG_SOUND")
	elif(textregion==39 && !Globals.get("TextScrolling")):
		textregion=40
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_16"), get_node("SE"), "MSG_SOUND")
	elif(textregion==40 && !Globals.get("TextScrolling")):
		textregion=41
		get_node("Box_message_002").set_opacity(1)
		get_node("Box_message_000").set_opacity(0)
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_09"), get_node("SE"), "MSG_SOUND")
	elif(textregion==41 && !Globals.get("TextScrolling")):
		textregion=42
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_10"), get_node("SE"), "MSG_SOUND")
	elif(textregion==42 && !Globals.get("TextScrolling")):
		textregion=43
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_11"), get_node("SE"), "MSG_SOUND")
	elif(textregion==43 && !Globals.get("TextScrolling")):
		textregion=44
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("YUUGURE_INTRO_TEXT_12"), get_node("SE"), "MSG_SOUND")
	elif(textregion==44 && !Globals.get("TextScrolling")):
		textregion=45
		get_node("Box_message_002").set_opacity(0)
		get_node("Box_message_000").set_opacity(1)
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_17"), get_node("SE"), "MSG_SOUND")
	elif(textregion==45 && !Globals.get("TextScrolling")):
		textregion=46
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_18"), get_node("SE"), "MSG_SOUND")
	elif(textregion==46 && !Globals.get("TextScrolling")):
		textregion=47
		get_node("/root/global").textscroll(get_node("Text_Messages"), tr("KIRYOKU_INTRO_TEXT_19"), get_node("SE"), "MSG_SOUND")
	elif(textregion==47 && !Globals.get("TextScrolling")):
		get_node("Keyblade_Anim").stop()
		get_node("Box_message_039b").set_pos(Vector2(0,0))
		get_node("End_Anim").play("End_Anim")
		textregion=48
	elif(textregion==48 && !Globals.get("TextScrolling")):
		if(!get_node("End_Anim").is_playing()):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Battle_Yuugure.scn")
func _ready():
	# Initialization here
	set_process(true)
	pass


