extends BaseSpellScript
class_name FireballScript


func _ready():
	super()
	projectileSpeed = 600.0
	deceleration = 200.0
	minSpeed = 200.0
	global_position = caster.global_position + Vector2(0, -32)

func _process(delta):
	projectileSpeed -= deceleration * delta
	projectileSpeed = max(projectileSpeed, minSpeed)
	if isMoving:
		for unitPosition in targetsPosition:
			global_position = global_position.move_toward(unitPosition, projectileSpeed*delta)
			if global_position == unitPosition:
				emit_signal("spellFinishedCasting")
				exit()

