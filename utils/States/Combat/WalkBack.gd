extends State
class_name WalkingBack


func enter():
	owner.isWalking = true
	owner.anim.play("walk")
	owner.anim.scale.x = -1

func update(delta):
	owner.walk(delta, owner.startingPosition)

func exit():
	owner.isWalking = false
	owner.endingTurn()
