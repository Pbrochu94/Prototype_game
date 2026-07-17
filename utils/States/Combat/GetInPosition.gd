extends State
class_name GetInPositionState

var player:UnitInstance
var target:UnitInstance
var attackSelected:Ability

func enter():
	player = owner.unit
	target = player.scene.target
	attackSelected = player.scene.attackSelected
	owner.isWalking = true
	owner.anim.play("walk")

func exit():
	owner.isWalking = false
	owner.anim.stop()


func update(delta):
	if not owner.attackSelected.needToMove:
		owner.attack()
	var targetPosition = owner.target.global_position
	var offset:float
	if owner.global_position.x < targetPosition.x:
		offset = -32
	else:
		offset = 32
	var desiredPosition = Vector2(
		targetPosition.x + offset,
		targetPosition.y
	)
	owner.walk(delta, desiredPosition)
