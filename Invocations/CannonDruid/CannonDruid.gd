extends BaseUnitScript
class_name CannonUnitScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"cannon shot" : preload("res://Invocations/CannonDruid/Attacks/Cannonshot.tres"),
	"rebuild": preload("res://Invocations/CannonDruid/Attacks/DruidHeal.tres")
	}

func initStats():
	characterName = "Cannon droid"
	walkSpeed = 200
	maxHp = 50
	currentHp = 50
	speed = 1
