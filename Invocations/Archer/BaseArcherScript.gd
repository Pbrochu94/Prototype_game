extends BaseUnitScript
class_name BaseArcherScript

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"bow shot" : preload("res://Invocations/Archer/Attacks/BowShot/BowShot.tres"),
	"bow power shot" : preload("res://Invocations/Archer/Attacks/BowPowerShot/BowPowerShot.tres")
	}

func initStats():
	pass
