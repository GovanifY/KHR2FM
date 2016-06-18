extends Node2D

#Pour vérifier si le splash initial est terminé
var hasbeenset = false
#Mode du menu du CTS
var ModeNew = 0
#Pour vérifier si une touche a été pressée(pour ne pas avoir chaque frame une action avec un bouton!)
var keypressed =false
#Pour vérifier si on est dans le menu du nouveau jeu
var New_Window = false
#Pour vérifier si on est dans le menu des sauvegardes
var Save_Window = false
#Pour vérifier si on est sur l'anim' initiale du menu des sauvegardes
var Save_Window_Anim = false
#Mode du menu du Nouveau jeu
var SelectMode = 0
#Mode du menu des sauvegardes
var SelectSave = 0
#Pour vérifier si on est en train de quitter le jeu
var Quitting=false
#Pour vérifier si on est en train de lancer le jeu
var NewGameLaunched = false
#Les différentes sauvegardes
var save1 = File.new()
var save2 = File.new()

func _process(delta):

	if (hasbeenset== false || NewGameLaunched==true ||Save_Window_Anim==true):
		if(hasbeenset==false):
			if(!get_node("SplashAndMenuShowUp").is_playing()):
				#Si le splash est terminé et que les anims ont pas encore été lancées ont les lance.
				get_node("Custom Title System/Final_Flash").play("Final_Flash")
				get_node("Custom Title System/BG_1").play("BG_1")
				get_node("Custom Title System/BG_2").play("BG_2")
				get_node("Custom Title System/Light_1").play("Light_1")
				hasbeenset=true
		elif(NewGameLaunched==true):
			Globals.set("TimerActivated", true)
			if(SelectMode==0):
				if(!get_node("Custom Title System/NewGame_1").is_playing()):
					Globals.set("Critical", false)
					get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Aqua.tscn")
			elif(SelectMode==1):
				if(!get_node("Custom Title System/NewGame_2").is_playing()):
					Globals.set("Critical", true)
					get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Splash/EXP_Zero.tscn")
		elif(Save_Window_Anim==true):
			if(!get_node("Custom Title System/SplashSave").is_playing()):
				Save_Window_Anim=false
				Save_Window=true

	else:
		var up = false
		var down = false
		var confirm = false
		var cancel = false

		#Le menu est lancé, donc il vaudrait mieux gérer les inputs de l'user!
		#On s'occupe ici de savoir les touches pressées
		if Input.is_action_pressed("ui_up"):
			up = true

		if Input.is_action_pressed("ui_down"):
			down = true

		if Input.is_action_pressed("enter"):
			confirm = true

		if Input.is_action_pressed("cancel"):
			cancel = true

		if(New_Window==false && Save_Window==false && Quitting==false):
			#Si on est dans le CTS on fait les 3 cas de figures: si on appuies sur haut, bas ou entrée
			if (down == true && keypressed == false):
				get_node("Custom Title System/System").play("System_03")
				ModeNew = ModeNew + 1
				if ModeNew > 2:
					ModeNew = 0
				keypressed=true
				if(ModeNew==2):
					get_node("Custom Title System/Light_2").stop()
					get_node("Custom Title System/Light_3").play("Light_3")
				elif(ModeNew==0):
					get_node("Custom Title System/Light_3").stop()
					get_node("Custom Title System/Light_1").play("Light_1")
				elif(ModeNew==1):
					get_node("Custom Title System/Light_1").stop()
					get_node("Custom Title System/Light_2").play("Light_2")

			if (up == true && keypressed == false):
				get_node("Custom Title System/System").play("System_03")
				ModeNew = ModeNew - 1
				if ModeNew < 0:
					ModeNew = 2
				keypressed=true
				if(ModeNew==2):
					get_node("Custom Title System/Light_1").stop()
					get_node("Custom Title System/Light_3").play("Light_3")
				elif(ModeNew==1):
					get_node("Custom Title System/Light_3").stop()
					get_node("Custom Title System/Light_2").play("Light_2")
				elif(ModeNew==0):
					get_node("Custom Title System/Light_2").stop()
					get_node("Custom Title System/Light_1").play("Light_1")

			if (confirm == true && keypressed == false):
				get_node("Custom Title System/System").play("System_04")
				keypressed=true
				if(ModeNew==0):
					get_node("Custom Title System/SplashNew").play("SplashNew")
					New_Window=true
				elif(ModeNew==1):
					get_node("Custom Title System/SplashSave").play("SplashSave")
					get_node("Custom Title System/Cursor").play("Cursor")
					if !save1.file_exists("user://save1.sav"):
						get_node("Custom Title System/NoSave1").play("NoSave1")
					if !save2.file_exists("user://save2.sav"):
						get_node("Custom Title System/NoSave2").play("NoSave2")
					#TODO: (Juste pour m'en souvenir)
					#si la save existe on charge le reste(niveau, temps de jeu, endroit et visage)
					#sinon label "Aucune Sauvegarde"
					Save_Window_Anim=true
				elif(ModeNew==2):
					get_node("Custom Title System/QuitGame").play("QuitGame")
					Quitting=true

		#Si on est dans le menu new les 4: haut bas entrée annuler
		elif(New_Window==true):
			if (cancel == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("System_02")
				if(SelectMode==0):
					get_node("Custom Title System/UnsplashNew_1").play("UnsplashNew_1")
				elif(SelectMode==1):
					get_node("Custom Title System/UnsplashNew_2").play("UnsplashNew_2")
				New_Window=false
				SelectMode=0

			if(up == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("System_03")
				SelectMode = SelectMode - 1
				if SelectMode < 0:
					SelectMode = 1

			if(down == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("System_03")
				SelectMode = SelectMode + 1
				if SelectMode > 1:
					SelectMode = 0

			if (confirm == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("NewGame")
				if (SelectMode==0):
					get_node("Custom Title System/NewGame_1").play("NewGame_1")
				elif (SelectMode==1):
					get_node("Custom Title System/NewGame_2").play("NewGame_2")
				NewGameLaunched=true

			if(SelectMode==1):
				get_node("Custom Title System/Mode_00").set_opacity(0)
				get_node("Custom Title System/Mode_01").set_opacity(1)
			elif(SelectMode==0):
				get_node("Custom Title System/Mode_01").set_opacity(0)
				get_node("Custom Title System/Mode_00").set_opacity(1)


		#Et enfin si on est dans le menu de chargement les mêmes touches
		elif(Save_Window==true):
			if (cancel == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("System_02")
				get_node("Custom Title System/UnsplashSave").play("UnsplashSave")
				get_node("Custom Title System/Cursor").stop()
				SelectSave=0
				get_node("Custom Title System/Save_Load_04").set_opacity(0)
				get_node("Custom Title System/Save_Load_34").set_opacity(0)
				get_node("Custom Title System/Save_Load_05").set_opacity(0)
				get_node("Custom Title System/Save_Load_35").set_opacity(0)
				get_node("Custom Title System/LABEL_NOSAVE2").set_opacity(0)
				get_node("Custom Title System/LABEL_NOSAVE1").set_opacity(0)
				Save_Window=false

			if(up == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("System_03")
				SelectSave = SelectSave - 1
				if SelectSave < 0:
					SelectSave = 1

			if(down == true && keypressed == false):
				keypressed=true
				get_node("Custom Title System/System").play("System_03")
				SelectSave = SelectSave + 1
				if SelectSave > 1:
					SelectSave = 0

			if (confirm == true && keypressed == false):
				keypressed=true
				#TODO: (Juste pour m'en souvenir)
				#Si la save existe pas on lance juste ca, sinon on charge l'anim'
				if(SelectSave==1):
					if !save2.file_exists("user://save2.sav"):
						get_node("Custom Title System/System").play("System_01")
					else:
						print("Save exist, should be launched instead of printing!")
				elif(SelectSave==0):
					if !save1.file_exists("user://save1.sav"):
						get_node("Custom Title System/System").play("System_01")
					else:
						print("Save exist, should be launched instead of printing!")

			if(SelectSave==1 && Save_Window==true):
				get_node("Custom Title System/Save_Load_04").set_opacity(0)
				get_node("Custom Title System/Save_Load_34").set_opacity(0)
				get_node("Custom Title System/Save_Load_05").set_opacity(1)
				get_node("Custom Title System/Save_Load_35").set_opacity(1)
			elif(SelectSave==0 && Save_Window==true):
				get_node("Custom Title System/Save_Load_04").set_opacity(1)
				get_node("Custom Title System/Save_Load_34").set_opacity(1)
				get_node("Custom Title System/Save_Load_05").set_opacity(0)
				get_node("Custom Title System/Save_Load_35").set_opacity(0)

		elif(Quitting==true):
			if(!get_node("Custom Title System/QuitGame").is_playing()):
				get_tree().quit()

		if(keypressed==true && (up==false && down==false && confirm==false && cancel==false)):
			keypressed=false

func _ready():
	# Initialization here
	set_process(true)
	pass
