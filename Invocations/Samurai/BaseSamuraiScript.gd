extends BaseUnitScript
class_name BaseSamuraiScript

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"sword slash" : preload("res://Invocations/Samurai/Attacks/Sword slash/SwordSlash.tres").duplicate(true),
	"sword slam": preload("res://Invocations/Samurai/Attacks/Sword slam/SwordSlam.tres").duplicate(true),
}

func initStats():
	pass
