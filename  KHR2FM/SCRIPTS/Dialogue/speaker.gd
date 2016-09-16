# For reference, a Speaker works like this:
# Speaker = {
#	"name"    : name
#	"index"   : 0,
#	"count"   : count,
#	"mugshot" : mugshot
#}

var name
var index
var count
var mugshot

######################
### Core functions ###
######################
func _init(name, count, mugshot):
	self.name    = name
	self.index   = 0
	self.count   = count
	self.mugshot = mugshot
