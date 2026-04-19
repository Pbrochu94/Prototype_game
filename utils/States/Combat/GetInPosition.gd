extends State
class_name GetInPosition

@export var player:Node2D

func enter():
	owner.isWalking = true
	owner.anim.play("walk")

func exit():
	owner.isWalking = false

func _process(delta):
	pass


func update(delta):
	owner.walk(delta, owner.target.global_position)
