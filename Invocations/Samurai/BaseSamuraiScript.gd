extends BaseUnitScript
class_name BaseSamuraiScript

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"sword slash" : {
		"path": preload("res://Invocations/Samurai/Attacks/SwordSlash.tres"),
		"cooldown": 0,
		"currentCooldown":0,
		"justUsed": false
	},
	"sword slam": {
		"path": preload("res://Invocations/Samurai/Attacks/SwordSlam.tres"),
		"cooldown": 3,
		"currentCooldown": 0,
		"justUsed": false
	}
}

func initStats():
	pass
