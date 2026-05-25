extends BaseUnitScript
class_name CannonUnitScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"cannon shot" : preload("res://Invocations/CannonDruid/Attacks/Cannonshot.tres").duplicate(true),
	"rebuild":preload("res://Invocations/CannonDruid/Attacks/DruidHeal.tres").duplicate(true)
	}

func initStats():
	pass
