extends BaseUnitScript
class_name BaseBlasterDruidScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"gun shot" : preload("res://Invocations/BlasterDruid/Attacks/GunShot/GunShot.tres").duplicate(true),
	"instability scan" : preload("res://Invocations/BlasterDruid/Attacks/InstabilityScan/Scan.tres").duplicate(true)
	}

func initStats():
	pass

