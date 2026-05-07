extends GetInPositionState
class_name ArcherGetInPosition


func update(delta):
	var targetPosition = owner.target.global_position
	var offset:float
	if owner.global_position.x < targetPosition.x:
		offset = -100
	else:
		offset = 100
	var desiredPosition = Vector2(
		targetPosition.x + offset,
		targetPosition.y
	)
	owner.walk(delta, desiredPosition)
