extends BaseUnitScript

func _ready():
	super()
	initAttacks()

func initAttacks():
	attacks = {
	"fire slash" : preload("res://Invocations/LordOfFlames/Attacks/FireSlash.tres").duplicate(true),
#	"bow power shot" : preload("res://Invocations/Archer/Attacks/BowPowerShot/BowPowerShot.tres").duplicate(true)
	}
