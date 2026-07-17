extends GetInPositionState


func update(delta):
	var targetPosition = owner.target.scene.global_position
	var offset:float
	if owner.global_position.x < targetPosition.x:
		offset = -15
	else:
		offset = 15
	var desiredPosition = Vector2(
		targetPosition.x + offset,
		targetPosition.y
	)
	owner.walk(delta, desiredPosition)
