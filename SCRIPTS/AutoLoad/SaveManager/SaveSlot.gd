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
		"difficulty"   : KHR2.get("Difficulty"),
		"scene"        : current_scene,
		"world"        : KHR2.get("Map").world,
		"location"     : KHR2.get("Map").location,
		"playtime_hrs" : KHR2.get("Playtime").hrs,
		"playtime_min" : KHR2.get("Playtime").mins,

		# Save-specific content
		"avatar"       : avatar,

		# Stats
		"stats" : KHR2.get("Player").stats
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
func get_scene(): return get("scene")
func set_scene(value):   set("scene", value)
