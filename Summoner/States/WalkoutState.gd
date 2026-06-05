extends State

signal introFinished

func _onready():
	pass

func enter():
	owner.isWalking = true
	owner.def.walkSpeed = 160
	owner.anim.play("walk")

func update(delta):
	owner.walk(delta, owner.currentScene.exitAnchor.global_position)

func exit():
	owner.def.walkSpeed = owner.def.baseWalkSpeed
	print("AHHHH")
