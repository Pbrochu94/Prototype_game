extends BaseUnitScript

func _ready():
	super()
	initAttacks()

func initAttacks():
	attacks = {
	"fire slash" : preload("res://Invocations/LordOfFlames/Attacks/FireSlash/FireSlash.tres").duplicate(true),
	"combustion" : preload("res://Invocations/LordOfFlames/Attacks/Combustion/CombustionRes.tres").duplicate(true),
	"ablaze":preload("res://Invocations/LordOfFlames/Attacks/Ablaze/AblazeRes.tres").duplicate(true)
	}
