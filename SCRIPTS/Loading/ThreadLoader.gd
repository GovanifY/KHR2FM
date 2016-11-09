# Instance members
var processing = true
var has_progress = false

# Multi-Threading material
var queue   = Array()
var pending = Dictionary()

var mutex
var sem
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
func _init():
	mutex = Mutex.new()
	sem   = Semaphore.new()

func _print_progress():
	if has_progress:
		for path in queue: # FIXME: untested
			print("Loading: ", _get_progress(path))

# This function uses division, so it's best not to use it heavily
func _get_progress(path):
	_lock("get_progress")
	var ret = -1
	if path in pending:
		if pending[path] extends ResourceInteractiveLoader:
			ret = float(pending[path].get_stage()) / float(pending[path].get_stage_count())
		else:
			ret = 1.0
	_unlock("get_progress")

func _wait_for_resource(res, path):
	_unlock("wait_for_resource")
	while true:
		OS.delay_usec(16000) # wait 1 frame
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
			_print_progress()
		elif err == ERR_FILE_EOF || err != OK:
			var path = res.get_meta("path")
			if path in pending: # else it was already retrieved
				pending[res.get_meta("path")] = res.get_resource()

			queue.erase(res) # something might have been put at the front of the queue while we polled, so use erase instead of remove
	_unlock("process")

func _thread_loop(path):
	while !is_ready(path) && processing:
		_thread_process()

###############
### Methods ###
###############
func clear():
	_lock("clearing")
	processing = false
	queue.clear()
	pending.clear()
	_unlock("clearing")
	for thread in threads.values():
		if thread.is_active():
			thread.wait_to_finish()
	threads.clear()

func is_ready(path):
	var ret

	_lock("is_ready")
	if path in pending:
		ret = !(pending[path] extends ResourceInteractiveLoader)
	else:
		ret = false
	_unlock("is_ready")

	return ret

func queue_resource(path, p_in_front = false):
	_lock("queue_resource")
	if path in pending:
		_unlock("queue_resource")
		return

	processing = true

	if ResourceLoader.has(path):
		var res = ResourceLoader.load(path)
		pending[path] = res
		_unlock("queue_resource")
		return
	else:
		# Create a thread for this resource
		var thread = Thread.new()

		var err = thread.start(self, "_thread_loop", path, Thread.PRIORITY_LOW)
		if err != OK:
			OS.alert("Couldn't create a loading thread!", "ThreadLoader Error")
			_unlock("queue_resource")
			return
		threads[path] = thread

		var res = ResourceLoader.load_interactive(path)
		res.set_meta("path", path)
		if p_in_front:
			queue.push_front(res)
		else:
			queue.push_back(res)
		pending[path] = res
		_post("queue_resource")
		_unlock("queue_resource")
		return

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
