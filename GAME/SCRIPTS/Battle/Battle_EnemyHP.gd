extends CanvasLayer

var oldHP = 100
var maxHP = 100
onready var GreenBar = get_node("GreenBar")
onready var SlideHit = get_node("SlideHit")

######################
### Core functions ###
######################
func _ready():
	#set maxHP to Boss HP here
	pass	
func _set_HP(curHP):
	GreenBar.set_scale(Vector2(curHP/100,0))

func update(curHP):
	var curLine = curHP
	while curLine > 100:
		#TODO: Update for bubbles here
		curLine = curHP - 100
	_set_HP(curLine)
	if(curLine > oldHP):
		#Happens in debug or if heal or during one bubble shot
		#SlideHit is 2secs long so *2
		SlideHit.seek((curHP/100)*2)
		#TODO: Update the HP background in case maxHP%100!=0
		#and maxHP - curHP =< maxHP%100
	#TODO: Add Timer for life drawing anim and play SlideHit!
	oldHP = curLine

