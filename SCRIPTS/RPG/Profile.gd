extends Object

# RPG Classes
const RPG = "res://SCRIPTS/RPG/"

const Level       = preload(RPG + "Level.gd")
const PlayerStats = preload(RPG + "Stats/PlayerStats.gd")

# Constants
const MEMBERS =

# "Private" members
var level = Level.new()
var stats = PlayerStats.new()

func has(key):
	return key in ["level", "stats"]
