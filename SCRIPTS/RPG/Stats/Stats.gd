extends Object

# Contains modifiable stats.

# Signals
signal stat_changed(stat)
signal modifier_changed(id)

# Main material for stats:
	# base: base or preset stats.
		# A base is literally a pair of { name : value }
	# modifiers: these alter the value obtained from base stats
		# A modifier is of type Modifier, a separate class.
var base = {}
var modifiers = {}

######################
### Core functions ###
######################
func _init(copy={}):
	base = copy

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

###############
### Methods ###
###############
func print_stat(key):
	print("base_", key, " = ", get_base(key))
	print(key, " = ", get(key))

func print_stats():
	print("Base: ", base.to_json())
	print("Mods: ", modifiers.to_json())

### Basic stats
func set_base(key, value):
	base[key] = value
	emit_signal("stat_changed", key)

func get_base(key):
	return base[key] if base.has(key) else 0

# Adds a modifier
func add_modifier(id, mod):
	modifiers[id] = mod
	emit_signal("modifier_changed", id)

# Removes a modifier
func remove_modifier(id):
	modifiers.erase(id)
	emit_signal("modifier_changed", id)

# Sets the value of a single ID
func set_modifier(id, mod):
	if mod != null:
		add_modifier(id)
	else:
		remove_modifier(id)

# Retrieves given ID's modifier
func get_modifier(id):
	return modifiers[id]
