extends State
class_name GetInPositionBlasterDruid

@export var player:Node2D

func enter():
	owner.isWalking = true
	owner.anim.play("walk")

func exit():
	owner.isWalking = false
	owner.anim.stop()

func _process(delta):
	pass


func update(delta):
	var targetPosition = owner.target.global_position
	var offset:float
	if owner.global_position.x < targetPosition.x:
		offset = -140
	else:
		offset = 140
	var desiredPosition = Vector2(
		targetPosition.x + offset,
		targetPosition.y
	)
	owner.walk(delta, desiredPosition)
