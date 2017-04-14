# Signals
signal finished(path)

# Instance members
var Progress
var issued_kill = false
var can_quit = false
var has_progress = false

# Multi-Threading material
var queue   = Array()
var pending = Dictionary()

var mutex  = Mutex.new()
var sem    = Semaphore.new()
var thread = Thread.new()

func _lock(caller):
	#print("locking \"", caller, "\"")
	mutex.lock()

func _unlock(caller):
	#print("unlocking \"", caller, "\"")
	mutex.unlock()

func _post(caller):
	#print("posting \"", caller, "\"")
	sem.post()

func _wait(caller):
	#print("waiting for \"", caller, "\"")
	sem.wait()


###############################
### Loader thread functions ###
###############################
func _show_progress(res):
	mutex.lock()
	if has_progress:
		var progress = float()
		if res extends ResourceInteractiveLoader:
			progress = float(res.get_stage()) / float(res.get_stage_count())
		else:
			progress = 1.0
		progress *= 100

		# Updating Progress bar
		Progress.set_value(progress)
		# Also printing in the console
		print("Loading: ", progress)
	mutex.unlock()

func _thread_process():
	_wait("thread_process")

	while queue.size() > 0 && !issued_kill:
		_lock("process")
		var res = queue[0]

		_unlock("process_poll")
		var err = res.poll()
		_lock("process_check_queue")

		if err == OK: # Updating progress
			_show_progress(res)
		elif err == ERR_FILE_EOF:
			var path = res.get_meta("path")
			if path in pending: # else it was already retrieved
				pending[path] = res.get_resource()

			_show_progress(pending[path])
			queue.erase(res) # remove the loaded resfile
			emit_signal("finished", path)
		_unlock("process")

func _thread_loop(_):
	while !issued_kill:
		_thread_process()
	can_quit = true

#############################
### Main thread functions ###
#############################
func _init(progress_node):
	Progress = progress_node

	# Start thread
	var err = thread.start(self, "_thread_loop")
	if err != OK:
		OS.alert("Couldn't create a loading thread!", "ThreadLoader Error")

func _wait_for_resource(res, path):
	_unlock("wait_for_resource")
	while true:
		VisualServer.call("sync")
		OS.delay_msec(16) # wait 1 frame
		_lock("wait_for_resource")
		if queue.size() == 0 || queue[0] != res:
			return pending[path]
		_unlock("wait_for_resource")

func _wait_for_thread():
	_unlock("wait_for_thread")
	while true:
		VisualServer.call("sync")
		OS.delay_msec(16) # wait 1 frame
		_lock("wait_for_thread")
		if can_quit:
			return
		_unlock("wait_for_thread")

func clear():
	issued_kill = true
	#breakpoint
	if thread.is_active():
		_post("wait_to_finish")
		_wait_for_thread()
		thread.wait_to_finish()
	queue.clear()
	pending.clear()

	issued_kill = false

func is_ready(path):
	var ret = false

	mutex.lock()
	if path in pending:
		ret = !(pending[path] extends ResourceInteractiveLoader)
	mutex.unlock()

	return ret

func set_progress(value):
	_lock("set_progress")
	has_progress = value
	Progress.set_hidden(!value)
	_unlock("set_progress")

func queue_resource(path, p_in_front = false):
	_lock("queue_resource")
	if path in pending:
		_unlock("queue_resource")
		return

	if ResourceLoader.has(path):
		var res = ResourceLoader.load(path)
		pending[path] = res
	else:
		# Prepare data
		var res = ResourceLoader.load_interactive(path)
		res.set_meta("path", path)
		if p_in_front:
			queue.push_front(res)
		else:
			queue.push_back(res)
		pending[path] = res

		_post("queue_resource")
	_unlock("queue_resource")

func get_resource(path):
	_lock("get_result")
	if path in pending:
		var res = pending[path]
		if res extends ResourceInteractiveLoader:
			if res != queue[0]:
				# Putting res in front of queue
				var pos = queue.find(res)
				queue.remove(pos)
				queue.push_front(res)

			res = _wait_for_resource(res, path)
		pending.erase(path)
		_unlock("return")
		return res
	else:
		_unlock("return")
		return ResourceLoader.load(path)

func cancel_resource(path):
	_lock("cancel_resource")
	if path in pending:
		if pending[path] extends ResourceInteractiveLoader:
			queue.erase(pending[path])
		pending.erase(path)
	_unlock("cancel_resource")
