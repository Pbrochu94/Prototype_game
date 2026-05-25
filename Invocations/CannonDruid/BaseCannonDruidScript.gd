extends BaseUnitScript
class_name CannonUnitScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"cannon shot" : preload("res://Invocations/CannonDruid/Attacks/CannonShot/Cannonshot.tres").duplicate(true),
	"rebuild":preload("res://Invocations/CannonDruid/Attacks/Rebuild/Rebuild.tres").duplicate(true)
	}

func initStats():
	pass
