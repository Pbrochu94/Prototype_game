extends BaseUnitScript
class_name BaseArcherScript

func _ready():
	super()
	initAttacks()

func initAttacks():
	attacks = {
	"bow shot" : preload("res://Invocations/Archer/Attacks/BowShot/BowShot.tres").duplicate(true),
	"bow power shot" : preload("res://Invocations/Archer/Attacks/BowPowerShot/BowPowerShot.tres").duplicate(true)
	}

