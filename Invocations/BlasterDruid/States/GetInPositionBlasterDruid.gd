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
	owner.walk(delta, owner.target.global_position)
