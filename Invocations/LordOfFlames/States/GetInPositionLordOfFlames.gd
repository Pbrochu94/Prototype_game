extends GetInPositionState

func update(delta):
	var targetPosition = owner.target.global_position
	var offset:float
	if owner.global_position.x < targetPosition.x:
		offset = -50
	else:
		offset = 50
	var desiredPosition = Vector2(
		targetPosition.x + offset,
		targetPosition.y
	)
	owner.walk(delta, desiredPosition)
