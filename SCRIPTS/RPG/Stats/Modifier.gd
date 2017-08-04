extends Object

# Structured for modifiers.

var add = {}
var mul = {}

######################
### Core functions ###
######################
func _init(copy):
	add = copy.add if copy.has("add") else {}
	mul = copy.mul if copy.has("mul") else {}

###############
### Methods ###
###############
func print_stat(key):
	print("add[", key, "] = ", get_add(key))
	print("mul[", key, "] = ", get_mul(key))

func print_stats():
	print("add = ", add.to_json())
	print("mul = ", mul.to_json())

### Basic stats
func set_add(key, value):
	add[key] = value
func set_mul(key, value):
	mul[key] = value if 0 < value && value <= 1 else 0

func get_add(key):
	return add[key] if add.has(key) else 0
func get_mul(key):
	return mul[key] if mul.has(key) else 0
