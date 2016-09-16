extends Thread

var scene_next = null

var has_loaded = false
var has_progress = false

# Signal
signal scene_ready
signal scene_error

# Multi-Threading material
var mutex

func _lock(caller):
	mutex.lock()

func _unlock(caller):
	mutex.unlock()

######################
### Core functions ###
######################
func _print_progress():
	_lock("print_progress")
	if has_progress:
		print("Loading: ", _get_progress())
	_unlock("print_progress")
	return

# This function uses division, so it's best not to use it heavily
func _get_progress():
	_lock("get_progress")
	var ret = -1
	if scene_next extends ResourceInteractiveLoader:
		ret = float(scene_next.get_stage()) / float(scene_next.get_stage_count())
	else:
		ret = 1.0
	_unlock("get_progress")

	return ret

func _set_readiness():
	_lock("_set_readiness")
	has_loaded = true
	emit_signal("scene_ready")
	_unlock("_set_readiness")

# Thread-related
func _thread_process():
	_lock("process")
	if is_ready(): # no more loading
		_unlock("process")
		return

	# poll your next Scene
	_unlock("process_poll")
	var err = scene_next.poll()
	_lock("process_check_queue")

	if err == ERR_FILE_EOF: # load finished
		_set_readiness()
	elif err == OK: # Updating progress
		_print_progress()
	else:
		# Loading error: some files probably weren't loaded.
		# FIXME: Quitting is too much; think of an alternative scenario in
		# FIXME: case of failure
		OS.alert("There was a problem loading the next scene.", "Loading error!")
		emit_signal("scene_error")
		set_loop_mode(false)
		return

	_unlock("process")
	return

func _thread_loop(nothing):
	while !is_ready():
		_thread_process()


###############
### Methods ###
###############
func clear():
	scene_next = null

func result():
	return scene_next

func add_scene(loaded_scene):
	scene_next = loaded_scene
	has_loaded = false

func is_ready():
	return has_loaded

func start_loader(debug = false):
	mutex = Mutex.new()

	if !debug:
		var err = start(self, "_thread_loop", PRIORITY_LOW)
		if err != OK:
			OS.alert("Couldn't create a loading thread!", "ThreadLoader Error")
			emit_signal("scene_error")
	else: # Debug-only: Doesn't launch a thread.
		_thread_loop(0)
	return
