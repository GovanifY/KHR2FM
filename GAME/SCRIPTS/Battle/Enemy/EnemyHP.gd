onready var GreenBar = get_node("GreenBar")
onready var SlideHit = get_node("SlideHit")

######################
### Core functions ###
######################
func _ready():
	#set maxHP to Boss HP here
	pass

func _set_bar_length(curHP):
	GreenBar.set_scale(Vector2(float(curHP)/100,1))

###############
### Methods ###
###############
func update(oldHP, curHP):
	var curLine = curHP
	while curLine > 100:
		#TODO: Update for bubbles here
		curLine = curHP - 100
	_set_bar_length(curLine)

	if curLine > oldHP:
		#Happens in debug or if heal or during one bubble shot
		#SlideHit is 2secs long so *2
		SlideHit.seek((curHP/100)*2)
		#TODO: Update the HP background in case maxHP%100!=0
		#and maxHP - curHP =< maxHP%100
	#TODO: Add Timer for life drawing anim and play SlideHit!
	# ^ Either this, or use Tweening!
	oldHP = curLine
