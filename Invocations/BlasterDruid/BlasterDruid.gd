extends BaseUnitScript
class_name BaseBlasterDruidScript


func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"gun shot" : preload("res://Invocations/BlasterDruid/Attacks/GunShot.tres")
	}

func initStats():
	characterName = "Blaster droid"
	walkSpeed = 200
	maxHp = 100
	currentHp = 100
	speed = 2

