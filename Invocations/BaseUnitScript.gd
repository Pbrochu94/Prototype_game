extends Node2D
class_name BaseUnitScript

#NODES
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var startingPosition:Vector2
@onready var hitboxShape = $Hitbox/CollisionShape2D
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 
@onready var spriteOrientation:Node2D = $SpritePivot
@onready var area = $Area2D
var partyManager:Node

#VARIABLES
var target:Node2D
var multipleTargets:Array[Node2D]
var collateralTargets:Array[Node2D]
var canBeSelected = false
var currentState:String
var isWalking = false
var direction:int
var states:Dictionary
@export var faction:Enum.Faction

#STATS
@onready var stats:Dictionary = {
	"maxHp": maxHp,
	"currentHp": currentHp,
	"atk": atk,
	"deff":deff,
	"speed":speed
}
@export var characterName:String 
@export var walkSpeed:int
@export var maxHp:int 
@export var currentHp:int 
@export var speed:int 
@export var attacks:Dictionary = {}
@export var attackSelected:Ability
@export var deff:int
@export var atk:int
var activeEffects:Array[Dictionary] = []
var abilityCooldown:int

#TIMERS
var timers:Dictionary = {
	"debuffs" : {
		"deff" : 0,
		"atk" : 0,
		"speed" : 0,
		},
	"buffs" : {
		"deff" : 0,
		"atk" : 0,
		"speed" : 0,
		},
	"status": {
		"poisonned":0,
		"burn":0,
		"freeze":0,
		}
}



#STATUS
var isDead:bool = false

#SIGNALS
signal introFinished
signal inPositionToAttack(enemy:Node2D)
signal stopSelectingTarget
signal dealDamage(amount:int)
signal turnFinished
signal startSelectingEnemyTarget
signal selectedSelf()
signal hpChanged(currentHp, maxHp)
signal isDowned(character)
signal hovered(character)
signal unhovered(character)
signal enemySelected(enemy:Node2D)
signal donePreparing
signal clickedOn(unit:Node2D)


# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize state machine on this character
	stateMachine.init(self)
	setState("idle")
	connectSignals()
	linkToFactionParty()

#ANIMATIONS & SPRITES
func onAnimationFinished():
	match currentState:
		"attacking":
			print(attackSelected.attackName)
#			if anim.animation == attackSelected.attackName:
			if attackSelected.needToMove:
				setState("walkingback")
			else:
				setState("idle")
				setState("endingturn")
		"hurt":
			if anim.animation == "hurt":
				if stats["currentHp"] <= 0:
					setState("downed")
				else:
					setState("idle")
		"heal":
			if anim.animation == attackSelected.attackName:
				setState("endingturn")
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction

#INIT
func connectSignals():
	turnManager.targetSelectionStarted.connect(isSelectable)
	inPositionToAttack.connect(attack)
	anim.animation_finished.connect(onAnimationFinished)

#BEHAVIORS
func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	if stateMachine.currentState == states["getinposition"]:
		if global_position == destination:
			isWalking = false
			attack(target, attackSelected)
	else:
		if global_position == destination:
			setState("endingturn")
			isWalking = false
func receiveDamage(attacker,attack, damage):
		var trueDamage:int = damage - stats["deff"]
		print(attacker)
		print("Character: ", attacker.characterName, " attack ", self.characterName, " for ", damage, "(damage+atk) ", attack.element, " damage minus ", stats["deff"],"(deff) for a total of ",trueDamage)
		print(characterName," has ", currentHp, " hp before attack ")
		stateMachine.setState(stateMachine.states["hurt"])
		stats["currentHp"]-= trueDamage
		emit_signal("hpChanged")
		print(characterName," now have ", stats["currentHp"], " hp after attack ")
func applyEffect(attack:Ability):
	for statAffected in attack.statsAffected:
		var effectApplied = {
			"stat":statAffected,
			"amount": convertPourcentage(stats[statAffected],attack.effectAmount),
			"duration": attack.effectDuration
		}
		print(characterName, " received the effect ", effectApplied)
		stats[effectApplied["stat"]] += effectApplied["amount"]
		activeEffects.append(effectApplied)
#	match attack.statusEffect:
#		StatusEffect.DEBUFF:
#			print(attack.statsAffected)
#			for statAffected in attack.statsAffected:
#				stats[statAffected] -= convertPourcentage(stats[statAffected],attack.effectAmount)
#				timers["debuffs"][statAffected] += attack.effectDuration
#				print("Target: ", characterName, " after debuff ", stats[statAffected], " for ", attack.effectDuration, " turn")


#TURN FLOW
func enemyStartTurn():
	print(characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(characterName, " chose the attack: ", attackSelected.attackName)
	enemyChooseTarget(attackSelected.numberOfTargets)
	emit_signal("donePreparing", target)
#	var nmbOfTargetToSelect =  attackSelected.numberOfTargets
#	var unitSelectable = turnManager.playerPartyManager.currentlyAliveCharacters
#	var nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
#	print("Enemy select ", nmbOfAvailableTargets, " targets")
#	for i in range(nmbOfAvailableTargets):
#		target = enemyChooseTarget()
#		print("Enemy ",self.characterName, " selected ", target)
#		attack(target, attackSelected)
#	emit_signal("donePreparing", target)
#	match attackSelected.focusType:
#		Enum.FocusType.ENEMY_SINGLE, Enum.FocusType.ENEMY_AOE:
#			target = enemyChooseTarget()
#			print("Chosen target: ", target)
#			emit_signal("donePreparing", target)
#		Enum.FocusType.ENEMY_MULTIPLE:
#			pass
#		Enum.FocusType.ALLY_SINGLE:
#			#emit_signal(startSelectingAllyTarget)
#			pass
#		Enum.FocusType.ALLY_MULTIPLE:
#			#emit_signal(startSelectingAllyTarget)
#			pass
#		Enum.FocusType.ENEMY_AOE:
#			pass
#		Enum.FocusType.SELF:
#			target = self
#			if attackSelected.type == Enum.AbilityType.HEAL:
#				setState("heal")
#			elif attackSelected.type == Enum.AbilityType.EFFECT:
#				pass
func onChosenAttack(index:int):
	attackSelected = attacks.values()[index]["path"]
	print("Attack selected: ", attackSelected.attackName)
	print("Focus type : ",Enum.FocusType.keys()[attackSelected.focusType])
	match attackSelected.focusType:
		Enum.FocusType.ENEMY_SINGLE, Enum.FocusType.ENEMY_AOE:
			emit_signal("startSelectingEnemyTarget", attackSelected.focusType, 1)
		Enum.FocusType.ENEMY_MULTIPLE:
			emit_signal("startSelectingEnemyTarget", attackSelected.focusType, attackSelected.numberOfTargets)
		Enum.FocusType.ALLY_SINGLE:
			#emit_signal(startSelectingAllyTarget)
			pass
		Enum.FocusType.ALLY_MULTIPLE:
			#emit_signal(startSelectingAllyTarget)
			pass
		Enum.FocusType.SELF:
			target = self
			if attackSelected.type == Enum.AbilityType.HEAL:
				setState("heal")
			elif attackSelected.type == Enum.AbilityType.EFFECT:
				pass
			emit_signal("selectedSelf")
func enemyChooseTarget(nmbOfTargetOfAttack:int):
	print(turnManager.playerPartyManager.currentlyAliveCharacters)
	var unitSelectable = turnManager.playerPartyManager.currentlyAliveCharacters.duplicate()
	var nmbOfAvailableTargets = min(nmbOfTargetOfAttack, unitSelectable.size())
	print("Enemy select ", nmbOfAvailableTargets, " targets")
	for i in range(nmbOfAvailableTargets):
		print(unitSelectable)
		target = unitSelectable.pick_random()
		print("Enemy ",self.characterName, " selected ", target)
		attack(target, attackSelected)
		unitSelectable.erase(target)
func getRandomAttack() -> Ability:
	var availableAtk = []
	for attackName in attacks:
		var attack = attacks[attackName]
		if attack["currentCooldown"] <= 0 :
			availableAtk.append(attack)
	var keys = attacks.keys()
	var randomAtk = availableAtk.pick_random()
	return randomAtk["path"]
func getInPosition(enemy:Node2D):
	target = enemy
	setState("getinposition")
func attack(enemy:Node2D,attack:Ability):
	setState("attacking")
	var attackName:String = attackSelected.attackName
	if attacks[attackName]["cooldown"] >  0:
		var cooldown:int = attacks[attackName]["cooldown"]
		print(attackName, " goes on a ", cooldown, " turn cooldown")
		attacks[attackName]["currentCooldown"] = cooldown
		attacks[attackName]["justUsed"] = true
	match attack.type:
		Enum.AbilityType.ATTACK:
			var atkStat = stats["atk"]
			var damageOutput:int = atkStat + attack.damage
			enemy.receiveDamage(self,attack,damageOutput)
			if attack.focusType == Enum.FocusType.ENEMY_AOE:
				print("SPLASH DAMAGE")
				for ally in enemy.partyManager.currentlyAliveCharacters:
					if ally != target:
						var splashDamage = attack.splashDamage + atkStat
						ally.receiveDamage(self,attack,splashDamage)
						print(ally.characterName, " received ", attack.splashDamage, " of splash damage")
						print(ally, " stats after AOE: ", ally.getUnitInfo())
		Enum.AbilityType.EFFECT:
			enemy.applyEffect(attackSelected)
	print(characterName," Attacked: ", enemy.characterName)
func attackFinished():
	print("Attack finished")
	if self.global_position != self.startingPosition:
		setState("walkingback")
	else:
		setState("endingturn")
func endingTurn():
	print("Player end turn")
	setState("idle")
	emit_signal("turnFinished")

#UI & SELECTION
func isSelectable():
	canBeSelected = true
	area.monitoring = true
func endSelection():
	canBeSelected = false
func onMouseEntered():
	if not isDead and canBeSelected:
		emit_signal("hovered", self)
	else:
		return
func onMouseExited():
	emit_signal("unhovered", self)
func onArea2DInputEvent(viewport, event, shape_idx):
	if not canBeSelected:
		return
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clickedOn", self)

#UTILS
func setState(newState:String):
	stateMachine.setState(states[newState])
func getUnitInfo():
	return {
		"Name": characterName,
		"Stats": stats,
		"Active effects": activeEffects
	}
func reduceTimers():
	for effect in activeEffects:
		if effect["duration"] > 0:
			effect["duration"] -= 1
		else: 
			stats[effect["stat"]] -= effect["amount"]
			activeEffects.erase(effect)
	for attack in attacks:
		if attacks[attack]["currentCooldown"] > 0 and not attacks[attack]["justUsed"]:
			attacks[attack]["currentCooldown"] -= 1
			print("attack: ",attack," cd = ", attacks[attack]["currentCooldown"])
		print(attacks[attack])
		attacks[attack]["justUsed"] = false
func convertPourcentage(baseStat:int, amount:int):
	var amountInPercent:float = float(amount)/100
	var value:float = baseStat * amountInPercent
	if value > 0:
		return ceil(value)
	else:
		return floor(value)
func linkToFactionParty():
	if faction == Enum.Faction.PLAYER:
		partyManager = get_tree().get_first_node_in_group("player party manager")
	else:
		partyManager = get_tree().get_first_node_in_group("enemy party manager")

