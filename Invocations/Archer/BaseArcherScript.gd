extends BaseUnitScript
class_name BaseArcherScript

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"bow shot" : preload("res://Invocations/Archer/Attacks/BowShot.tres"),
	"power bow shot" : preload("res://Invocations/Archer/Attacks/BowPowerShot.tres")
	}

func initStats():
	characterName = "Archer"
	walkSpeed = 200
	maxHp = 100
	currentHp = 100
	speed = 4
