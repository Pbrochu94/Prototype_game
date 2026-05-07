extends IdleState
class_name SummonerIdleState



func enter():
	owner.anim.play("idle")
	owner.orientSprite(1)
