# Signals
signal finished(path)

# Instance members
var has_progress = false
var Progress

# Multi-Threading material
var queue   = Array()
var pending = Dictionary()

var mutex = Mutex.new()
var sem   = Semaphore.new()
var threads = Dictionary()

func _lock(caller):
	mutex.lock()

func _unlock(caller):
	mutex.unlock()

func _post(caller):
	sem.post()

func _wait(caller):
	sem.wait()


######################
### Core functions ###
######################
func _init(progress_node):
	Progress = progress_node

func _show_progress(res):
	_lock("show_progress")
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
	_unlock("show_progress")

func _wait_for_resource(res, path):
	_unlock("wait_for_resource")
	while true:
		OS.delay_msec(16) # wait 1 frame
		_lock("wait_for_resource")
		if queue.size() == 0 || queue[0] != res:
			return pending[path]
		_unlock("wait_for_resource")

# Thread-related
func _thread_process():
	_wait("thread_process")

	_lock("process")
	while queue.size() > 0:
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
			queue.erase(res) # something might have been put at the front of the queue while we polled, so use erase instead of remove
	_unlock("process")

func _thread_loop(path):
	while !is_ready(path):
		_thread_process()
	emit_signal("finished", path)

###############
### Methods ###
###############
func clear():
	_lock("clearing")
	for thread in threads.values():
		if thread.is_active():
			_unlock("waiting_to_finish")
			thread.wait_to_finish()
			_lock("waiting_to_finish")
	threads.clear()
	queue.clear()
	pending.clear()
	_unlock("clearing")

func is_ready(path):
	var ret = false

	_lock("is_ready")
	if path in pending:
		ret = !(pending[path] extends ResourceInteractiveLoader)
	_unlock("is_ready")

	return ret

func set_progress(value):
	_lock("toggle_progress")
	has_progress = value
	Progress.set_hidden(!value)
	_unlock("clearing")

func queue_resource(path, p_in_front = false):
	_lock("queue_resource")
	if path in pending:
		_unlock("queue_resource")
		return

	if ResourceLoader.has(path):
		var res = ResourceLoader.load(path)
		pending[path] = res
	else:
		# Create a thread for this resource
		var thread = Thread.new()

		# Prepare data
		var res = ResourceLoader.load_interactive(path)
		res.set_meta("path", path)
		if p_in_front:
			queue.push_front(res)
		else:
			queue.push_back(res)
		pending[path] = res

		# Start thread
		var err = thread.start(self, "_thread_loop", path, Thread.PRIORITY_LOW)
		if err != OK:
			OS.alert("Couldn't create a loading thread!", "ThreadLoader Error")
			_unlock("queue_resource")
			cancel_resource(path)
			return
		threads[path] = thread

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
		threads[path].wait_to_finish()
		threads.erase(path)
		return res
	else:
		_unlock("return")
		return ResourceLoader.load(path)

func cancel_resource(path):
	_lock("cancel_resource")
	if path in pending:
		if pending[path] extends ResourceInteractiveLoader:
			queue.erase(pending[path])
		threads[path].wait_to_finish()
		threads.erase(path)
		pending.erase(path)
	_unlock("cancel_resource")
