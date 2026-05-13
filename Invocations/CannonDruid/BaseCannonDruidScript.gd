extends BaseUnitScript
class_name CannonUnitScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"cannon shot" : {
		"path":preload("res://Invocations/CannonDruid/Attacks/Cannonshot.tres"),
		"cooldown": 0,
		"currentCooldown":0,
		"justUsed": false
	},
	"rebuild":{
		"path": preload("res://Invocations/CannonDruid/Attacks/DruidHeal.tres"),
		"cooldown": 3,
		"currentCooldown":0,
		"justUsed": false
		} 
	}

func initStats():
	pass
