extends HurtState
class_name CannonDroidHurtState

func _onready():
	pass

func enter():
	owner.anim.play("hurt")

func update(delta):
	pass

func exit():
	pass


