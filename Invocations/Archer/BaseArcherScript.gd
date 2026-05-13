extends BaseUnitScript
class_name BaseArcherScript

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"bow shot" : {
		"path":preload("res://Invocations/Archer/Attacks/BowShot.tres"),
		"cooldown": 0,
		"currentCooldown":0,
		"justUsed": false
		},
	"bow power shot" : {
		"path":preload("res://Invocations/Archer/Attacks/BowPowerShot.tres"),
		"cooldown": 3,
		"currentCooldown":0,
		"justUsed": false
		}
	}

func initStats():
	pass
