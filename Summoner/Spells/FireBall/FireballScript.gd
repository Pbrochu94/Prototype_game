extends BaseSpellScript
class_name FireballScript


func _ready():
	super()
	projectileSpeed = 200
	global_position = caster.global_position + Vector2(0, -32)
	print("AHHHHH", targetsPosition)

func _process(delta):
	for unitPosition in targetsPosition:
		global_position = global_position.move_toward(unitPosition, projectileSpeed*delta)
