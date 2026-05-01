extends State
class_name WalkingBackBlasterDruid


func enter():
	owner.isWalking = true
	owner.anim.play("walk")
	if owner.is_in_group("enemy"):
		owner.orientSprite(owner.facingBackward)
	else:
		owner.anim.scale.x = -1

func update(delta):
	owner.walk(delta, owner.startingPosition)

func exit():
	owner.isWalking = false
	print("WHYYYY")
