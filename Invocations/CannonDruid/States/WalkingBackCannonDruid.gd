extends WalkingBackState
class_name CannonDroidWalkingBackState


func enter():
	owner.isWalking = true
	owner.anim.play("walk")
	if owner.faction == Enum.Faction.PLAYER:
		owner.orientSprite(-1)
	else:
		owner.orientSprite(1)

func update(delta):
	owner.walk(delta, owner.startingPosition)

func exit():
	owner.isWalking = false

