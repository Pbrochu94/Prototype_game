extends BaseUnitScript
class_name BaseBlasterDruidScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"gun shot" : preload("res://Invocations/BlasterDruid/Attacks/GunShot.tres"),
	"scan" : preload("res://Invocations/BlasterDruid/Attacks/Scan.tres")
	}

func initStats():
	pass

