extends BaseSpellScript
class_name FireballScript


func _ready():
	super()
	print(targets)
	projectileSpeed = 600.0
	deceleration = 200.0
	minSpeed = 200.0
	global_position = caster.global_position + Vector2(0, -32)

func _process(delta):
	projectileSpeed -= deceleration * delta
	projectileSpeed = max(projectileSpeed, minSpeed)
	if isMoving:
		for unit in targets:
			print(targets)
			var unitLocation = unit.global_position
			global_position = global_position.move_toward(unitLocation, projectileSpeed*delta)
			if global_position == unitLocation:
				emit_signal("spellFinishedCasting")
				unit.receiveDamage(caster,spellSelected ,spellSelected.damage)
				isMoving = false
				exit()
