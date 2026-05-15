extends GetInPositionState
class_name BlasterDroidGetInPositionState


func update(delta):
	if not owner.attackSelected.needToMove:
		player.attack(target, attackSelected)
	var targetPosition = owner.target.global_position
	print(owner.target)
	var offset:float
	if owner.global_position.x < targetPosition.x:
		offset = -160
	else:
		offset = 160
	var desiredPosition = Vector2(
		targetPosition.x + offset,
		targetPosition.y
	)
	owner.walk(delta, desiredPosition)
