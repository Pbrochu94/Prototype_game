extends State
class_name WalkingBackState


func enter():
	owner.isWalking = true
	owner.anim.play("walk")
	if owner.faction == owner.Faction.SUMMON:
		owner.orientSprite(-1)
	else:
		owner.orientSprite(1)

func update(delta):
	owner.walk(delta, owner.startingPosition)

func exit():
	owner.isWalking = false

