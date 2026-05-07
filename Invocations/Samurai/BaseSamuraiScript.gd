extends BaseUnitScript
class_name BaseSamuraiScript

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"sword slash" : preload("res://Invocations/Samurai/Attacks/SwordSlash.tres"),
	"sword slam": preload("res://Invocations/Samurai/Attacks/SwordSlam.tres")
	}

func initStats():
	pass
