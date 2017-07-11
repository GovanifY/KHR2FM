# Serializable dictionary filled with the most important info for a save file
var save_data = {}

func _init(data = null):
	if data != null:
		save_data = data
	else:
		update()
	return self

# Save data formatting
func update(current_scene=null, avatar=null):
	save_data = {
		# IMPORTANT DATA
		"difficulty"   : Globals.get("Difficulty"),
		"scene"        : current_scene,
		"world"        : Globals.get("Map").world,
		"location"     : Globals.get("Map").location,
		"playtime_hrs" : Globals.get("PlayTimeHours"),
		"playtime_min" : Globals.get("PlayTimeMinutes"),

		# Save-specific content
		"avatar"       : avatar,

		# Switches
		# Basic stats
		"lv"           : 1,
		"hp"           : 10,
		"attack"       : 1,
		"defense"      : 1,
		# Stat adders
		"keyblade"     : null,
		# TODO: Items, magic, abilities, limits
	}

# Dictionary methods overload
func empty():
	return save_data.empty()

func has(key):
	var has = save_data.has(key)
	if !has: print("SaveSlot: Non-existing member '", key, "'")
	return has

func get(key):
	return save_data[key] if has(key) else null

func set(key, value):
	if not has(key):
		return
	save_data[key] = value

# In addition to these above, you can write methods that have more verbose names
# so as to have more legible code when accessing this script.
func get_level(): return get("lv")
func set_level(value):   set("lv", value)

func get_scene(): return get("scene")
func set_scene(value):   set("scene", value)
