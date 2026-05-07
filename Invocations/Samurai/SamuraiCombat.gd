extends BaseUnitScript
class_name SamuraiCombat

func _ready():
	super()
	initAttacks()
	initStats()

func initAttacks():
	attacks = {
	"sword slash" : preload("res://Invocations/Samurai/Attacks/SwordSlash.tres"),
	"sword slam": preload("res://Invocations/Samurai/Attacks/SwordSlam.tres")
	}

func initStats():
	characterName = "Samurai"
	walkSpeed = 200
	maxHp = 100
	currentHp = 100
	speed = 1
