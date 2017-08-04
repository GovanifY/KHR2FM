extends Node

const Modifier  = preload("res://SCRIPTS/RPG/Stats/Modifier.gd")
const Stats     = preload("res://SCRIPTS/RPG/Stats/Stats.gd")
const BattlerStats = preload("res://SCRIPTS/RPG/Stats/BattlerStats.gd")

# "Weapons"
onready var kingdom_key = {
	"id"  : 1,
	"mod" : Modifier.new({
		"add" : {
			"str" : 1,
			"def" : 0,
		}
	})
}

# Status effects
onready var bravery = {
	"id"  : 2,
	"mod" : Modifier.new({
		"mul" : {
			"str" : 0.1,
			"def" : -0.1,
		}
	})
}
onready var curse = {
	"id"  : 3,
	"mod" : Modifier.new({
		"mul" : {
			"max_hp" : -0.5,
		}
	})
}

# Character (basic stats)
onready var character = Stats.new({
	"str" : 7,
	"def" : 3,
})

# Battler
onready var battler = BattlerStats.new({
	"max_hp" : 20, "max_mp" : 10,
	"hp"     : 20, "mp"     : 10,
	"str" : 7,
	"def" : 3,
})

func _ready():
	#test_one_stat()
	#test_equipment()
	#test_status()
	test_battle1()
	#test_battle2()
	get_tree().quit()

# Function Helpers
static func apply_mod(target, value):
	target.add_modifier(value.id, value.mod)
	target.print_stats()

static func remove_mod(target, value):
	target.remove_modifier(value.id)
	target.print_stats()

static func reset_mods(target):
	target.modifiers.clear()

####### TESTERS #######
func test_one_stat():
	character.print_stat("str")

	# Changing base value
	character.set_base("str", 8)
	character.print_stat("str")

func test_equipment():
	### "Equipping" stats ###
	print("This is Kingdom Key")
	kingdom_key.mod.print_stats()

	print("\nLet's equip it")
	character.add_modifier(kingdom_key.id, kingdom_key.mod)
	character.print_stat("str")

	print("\nLet's unequip it")
	character.remove_modifier(kingdom_key.id)
	character.print_stat("str")

func test_status():
	print("'Bravery' consists in:")
	bravery.mod.print_stats()

	print("\nYour character got 'Bravery'")
	character.add_modifier(bravery.id, bravery.mod)
	character.print_stat("str")
	character.print_stat("def")

	print("\n'Bravery' effect wore off")
	character.remove_modifier(bravery.id)
	character.print_stat("str")
	character.print_stat("def")

	reset_mods(character)

func test_battle1():
	print("Initial stats")
	battler.print_stats()

	print("\nYour battler got 'Bravery'")
	apply_mod(battler, bravery)

	print("\nYour battler got hit: -12")
	battler.set("hp", battler.get("hp")-12)
	battler.print_stats()

	print("\nYour battler got 'Curse'")
	apply_mod(battler, curse)

	print("\n'Curse' wore off")
	remove_mod(battler, curse)

	reset_mods(battler)

func test_battle2():
	print("Creating Battler stats from existing character:")
	character.print_stats()
	var new_battler = BattlerStats.new(character)

	print("\nCharacter successfully became a Battler")
	new_battler.print_stats()
