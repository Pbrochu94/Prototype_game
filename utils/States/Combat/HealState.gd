extends State
class_name HealState

var attackSelected:Ability
var characterMaxHp:int
var characterCurrentHp:int
var target:Node2D

func enter():
	attackSelected = owner.attackSelected
	if attackSelected.type == attackSelected.AbilityType.SELFHEAL:
		target = owner
		target.anim.play(attackSelected.attackName.to_lower())
	else:
		target = owner.target
		target.anim.play("heal")
	characterMaxHp = target.maxHp
	characterCurrentHp = target.currentHp
	owner.anim.play(attackSelected.attackName.to_lower())
	characterCurrentHp += attackSelected.healAmount
	healStopsToMaxHp()

func update(delta):
	pass

func exit():
	print("Hp BEFORE heal: ",owner.currentHp)
	owner.currentHp = characterCurrentHp
	print("Hp AFTER heal: ",owner.currentHp)

func healStopsToMaxHp():
	if characterCurrentHp > characterMaxHp:
		characterCurrentHp = characterMaxHp

