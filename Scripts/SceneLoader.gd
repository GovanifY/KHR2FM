extends Node

var loader
var wait_frames
var time_max = 100
var current_scene

#Ce script gère l'écran de chargement en background le temps qu'une scène soit chargée
#Ce script est en autoload, et requiert une animation de background.

func _ready():
    current_scene = get_tree().get_current_scene()

func goto_scene(path):
	#Pour éviter que la scène s'exécute encore
	call_deferred("_deferred_goto_scene",path)
	
func _deferred_goto_scene(path):
	loader = ResourceLoader.load_interactive(path)
	#Autant vérifier que le loader fonctionne!
	if loader == null:
		#Alors si ca arrive c'est vraiment la merde
		return
	set_process(true)
	#On supprime l'ancienne scene
	#ATTENTION PARFOIS LA SCENE EST DEJA FREED ET CA PLANTE(A FIXER)
	if !current_scene.is_queued_for_deletion():
		current_scene.queue_free()
	#On démarre l'animation de chargement
	get_node("/root/MainLoader/BGLoading").play("HeartLoading")
	get_node("/root/MainLoader/Heart_Loading").set_opacity(1)
	#On va laisser l'anim' au moins une seconde avant de charger une thread pour faire genre en gros
	wait_frames = 60

func _process(time):
	if loader == null:
		#Dans ce cas la la scène est déjà chargée donc autant supprimer les calls non nécessaires!
		set_process(false)
		return

	#On attends le nombre de frames nécessaire pour afficher l'anim'
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: #On utilise time_max pour vérifier combient de temps on bloque cette thread
		#On regarde le status du loader
		var err = loader.poll()
		if err == ERR_FILE_EOF: #Chargement terminé
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			#On stop l'anim' et on efface le sprite utilisé
			get_node("/root/MainLoader/BGLoading").stop()
			get_node("/root/MainLoader/Heart_Loading").set_opacity(0)
			
			break
		elif err == OK:
			#On a rien a mettre a jour donc on break
			break
		else:
			#Si on est la le chargement a aussi eu un problème...
			loader = null
			break


func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
