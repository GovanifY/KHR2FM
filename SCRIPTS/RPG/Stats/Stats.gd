extends Object

# Contains modifiable stats.

var base = {}
var modifiers = {}

######################
### Core functions ###
######################
func _init(copy={}):
	base = copy

###############
### Methods ###
###############
func print_stat(key):
	print("base_", key, " = ", get_base(key))
	print(key, " = ", get(key))

func print_stats():
	print(base.to_json())
	print(modifiers.to_json())

### Basic stats
func set_base(key, value):
	base[key] = value

func get_base(key):
	return base[key] if base.has(key) else 0

# Adds a modifier
func add_modifier(id, mod):
	modifiers[id] = mod

# Removes a modifier
func remove_modifier(id):
	modifiers.erase(id)

# Sets the value of a single ID
func set_modifier(id, mod):
	if mod != null:
		add_modifier(id)
	else:
		remove_modifier(id)

# Retrieves given ID's modifier
func get_modifier(id):
	return modifiers[id]

### Calculated stats
func _set(key, value):
	pass # do nothing

func _get(key):
	var total = get_base(key)

	for id in modifiers:
		var mod = modifiers[id]
		total += mod.get_add(key)
		total += mod.get_mul(key) * get_base(key)

	return total
