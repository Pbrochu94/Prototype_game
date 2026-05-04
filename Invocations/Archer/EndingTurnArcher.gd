extends State
class_name EndingTurnArcher


func _onready():
	pass

func enter():
	owner.anim.play("idle")
	#Make the enemy face left and the player face right
	if owner.faction == owner.Faction.SUMMON:
		owner.orientSprite(1)
	else:
		owner.orientSprite(-1)
	#CHeck if something affect (ex: poison etc)

func update(delta):
	owner.endingTurn()

func exit():
	pass


