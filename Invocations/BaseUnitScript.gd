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
@export var faction:Enum.Faction
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

#DATA
@export var unitCost:int

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
var activeEffects:Array[Effect] = []
var abilityCooldown:int

#EFFECTS
var isInvulnerable:bool = false

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
	if isInvulnerable:
		print(characterName, " is invulnerable and negated the attack from ", attacker)
		return
	var trueDamage:int = damage - stats["deff"]
	if trueDamage <= 0:
		trueDamage = 0
		print(attacker.characterName, " does no damage to ", characterName)
	else:
		print("Character: ", attacker.characterName, " attack ", characterName, " for ", damage, "(damage+atk) ", attack.element, " damage minus ", stats["deff"],"(deff) for a total of ",trueDamage)
		print(characterName," has ", stats["currentHp"], " hp before attack ")
		stats["currentHp"]-= trueDamage
		setState("hurt")
		#Wait end of animation and transform this function into async
#		await anim.animation_finished
		emit_signal("hpChanged")
		print(characterName," now have ", stats["currentHp"], " hp after attack ")
func applyEffect(attack):
	match attack.effectRes.type:
		Enum.StatusEffect.INVULNERABLE:
			isInvulnerable = true
			var effectApplied = attack.effectRes
#			var effectApplied = {
#					"type":"invulnerable",
#					"duration": attack.effectDuration
#					}
			activeEffects.append(effectApplied)
			print(characterName, " is now invulnerable for ", attack.effectRes.duration, " turn")
		Enum.StatusEffect.STAT_MODIFIER:
			for statAffected in attack.statsAffected:
				var effectApplied = {
					"type":"stat modifier",
					"stat":statAffected,
					"amount": convertPourcentage(stats[statAffected],attack.effectAmount),
					"duration": attack.effectDuration
					}
				print(characterName, " received the effect ", effectApplied)
				stats[effectApplied["stat"]] += effectApplied["amount"]
				activeEffects.append(effectApplied)


#TURN FLOW
func enemyStartTurn():
	print(characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(characterName, " chose the attack: ", attackSelected.attackName)
	match attackSelected.focusType:
		Enum.FocusType.ENEMY_SINGLE, Enum.FocusType.ENEMY_AOE:
			enemyChooseTarget(attackSelected.numberOfTargets)
#			emit_signal("donePreparing", target)
		Enum.FocusType.ENEMY_MULTIPLE:
			enemyChooseTarget(attackSelected.numberOfTargets)
		Enum.FocusType.ALLY_SINGLE:
			#emit_signal(startSelectingAllyTarget)
			pass
		Enum.FocusType.ALLY_MULTIPLE:
			#emit_signal(startSelectingAllyTarget)
			pass
		Enum.FocusType.ENEMY_AOE:
			pass
		Enum.FocusType.SELF:
			target = self
			if attackSelected.type == Enum.AbilityType.HEAL:
				setState("heal")
			elif attackSelected.type == Enum.AbilityType.EFFECT:
				pass
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
			pass
		Enum.FocusType.ALLY_MULTIPLE:
			pass
		Enum.FocusType.SELF:
			target = self
			if attackSelected.type == Enum.AbilityType.HEAL:
				setState("heal")
			elif attackSelected.type == Enum.AbilityType.EFFECT:
				pass
			emit_signal("selectedSelf")
func getRandomAttack() -> Ability:
	var availableAtk = []
	for attackName in attacks:
		var attack = attacks[attackName]
		if attack["currentCooldown"] <= 0 :
			availableAtk.append(attack)
	var keys = attacks.keys()
	var randomAtk = availableAtk.pick_random()
	return randomAtk["path"]
func enemyChooseTarget(nmbOfTargetOfAttack:int):
	var unitSelectable = turnManager.playerPartyManager.currentlyAliveCharacters.duplicate()
	var nmbOfAvailableTargets = min(nmbOfTargetOfAttack, unitSelectable.size())
	print("Enemy select ", nmbOfAvailableTargets, " targets")
	for i in range(nmbOfAvailableTargets):
		target = unitSelectable.pick_random()
		print("Enemy ",self.characterName, " selected ", target)
		if attackSelected.needToMove:
			getInPosition(target)
		else:
			attack(target, attackSelected)
		unitSelectable.erase(target)

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
			if attack.statusEffect != Enum.StatusEffect.NONE:
				applyEffect(attack)
			var atkStat = stats["atk"]
			var damageOutput:int = atkStat + attack.damage
			enemy.receiveDamage(self,attack,damageOutput)
			if attack.focusType == Enum.FocusType.ENEMY_AOE:
				print("SPLASH DAMAGE")
				for ally in enemy.partyManager.currentlyAliveCharacters:
					if ally != target:
						var splashDamage = attack.splashDamage + atkStat
						ally.receiveDamage(self,attack,splashDamage)
						print(ally.characterName, " received ", (attack.splashDamage + stats["atk"]), " of splash damage")
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
		effect["duration"] -= 1
		if effect["duration"]<= 0:
			activeEffects.erase(effect)
			match effect["type"]:
				"invulnerable":
					isInvulnerable = false
					var spell = get_node("ShieldEffect")
					spell.exit()
				"stat modifier":
					stats[effect["stat"]] -= effect["amount"]
	for attack in attacks:
		if attacks[attack]["currentCooldown"] > 0 and not attacks[attack]["justUsed"]:
			attacks[attack]["currentCooldown"] -= 1
			print("attack: ",attack," cd = ", attacks[attack]["currentCooldown"])
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

