extends State
class_name IdleCannonDruid


func _onready():
	pass

func enter():
	owner.anim.play("idle")
	if owner.faction == owner.Faction.SUMMON:
		owner.orientSprite(1)
	else:
		owner.orientSprite(-1)

func update(delta):
	pass

func exit():
	pass

