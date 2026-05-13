extends BaseUnitScript
class_name BaseBlasterDruidScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"gun shot" : {
		"path":preload("res://Invocations/BlasterDruid/Attacks/GunShot.tres"),
		"cooldown": 0,
		"currentCooldown":0,
		"justUsed": false
		},
	"instability scan" : {
		"path":preload("res://Invocations/BlasterDruid/Attacks/Scan.tres"),
		"cooldown": 3,
		"currentCooldown":0,
		"justUsed": false
		}
	}

func initStats():
	pass

