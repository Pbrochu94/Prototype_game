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
var target:BaseUnitScript
var multipleTargets:Array[BaseUnitScript]
var collateralTargets:Array[BaseUnitScript]
var canBeSelected = false
var currentState:String
var isWalking = false
var direction:int
var states:Dictionary
var previousState:String


#STATS
@export var stats : UnitDefinition

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
var hasRetaliation:bool = false

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
var isSelectingToSummon:bool = false

#SIGNALS
signal introFinished
signal inPositionToAttack(enemy:BaseUnitScript)
signal stopSelectingTarget
signal dealDamage(amount:int)
signal turnFinished
signal startSelectingEnemyTarget
signal selectedSelf()
signal hpChanged(currentHp, maxHp)
signal isDowned(character)
signal hovered(character:BaseUnitScript)
signal unhovered(character:BaseUnitScript)
signal enemySelected(enemy:BaseUnitScript)
signal donePreparing
signal clickedOn(unit:BaseUnitScript)
signal selectedForSummon(unit:UnitDefinition)


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
#			if anim.animation == attackSelected.attackName:
			if attackSelected.needToMove:
				setState("walkingback")
			else:
				setState("idle")
				setState("endingturn")
		"hurt":
			if anim.animation == "hurt":
				if stats.currentHp <= 0:
					setState("downed")
				else:
					setState(previousState)
		"heal":
			if anim.animation == attackSelected.attackName:
				setState("endingturn")
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction
func spawnVisuals(visual:PackedScene,target:BaseUnitScript):
	target.add_child(visual.instantiate())


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
		print(stats.characterName, " is invulnerable and negated the attack from ", attacker)
		return
	elif hasRetaliation:
		for effect in activeEffects:
			if effect.name == "retaliation":
				if !attacker.is_in_group("main character"):
					attacker.receiveDamage(self,effect,effect.amount)
	var trueDamage:int = damage - stats.deff
	if trueDamage <= 0:
		trueDamage = 0
		print(attacker.stats.characterName, " does no damage to ", stats.characterName)
	else:
		print("Character: ", attacker.stats.characterName, " attack ", stats.characterName, " for ", damage, "(damage+atk) ", attack.element, " damage minus ", stats.deff,"(deff) for a total of ",trueDamage)
		print(stats.characterName," has ", stats.currentHp, " hp before attack ")
		stats.currentHp-= trueDamage
		setState("hurt")
		emit_signal("hpChanged")
		print(stats.characterName," now have ", stats.currentHp, " hp after attack ")
func applyEffect(effect:Effect):
	print(effect.name, " is applied to: ", self)
	var effectApplied = effect.duplicate(true)
	print(stats.characterName, " is now ", effectApplied.name," for ", effect.duration, " turn")
	match effect.type:
		Enum.StatusEffect.INVULNERABLE:
			isInvulnerable = true
			activeEffects.append(effectApplied)
		Enum.StatusEffect.STAT_MODIFIER:
			for statAffected in effect.statsAffected:
				var modifier = int(stats.get(statAffected) * effectApplied.amount)
				if modifier == 0:
					modifier = sign(effectApplied.amount)
				effectApplied.amountAppliedToUnit = modifier
				stats.set(
					statAffected,
					stats.get(statAffected) + modifier
				)
				print(stats.characterName, " received the effect ", effectApplied.name)
				activeEffects.append(effectApplied)
		Enum.StatusEffect.HEAL:
				setState("heal")
		Enum.StatusEffect.RETALIATION:
			hasRetaliation = true
			activeEffects.append(effectApplied)


#TURN FLOW
func enemyStartTurn():
	print(stats.characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(stats.characterName, " chose the attack: ", attackSelected.attackName)
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
			if attackSelected.type == Enum.AbilityType.EFFECT:
				applyEffect(attackSelected.effectRes)
			emit_signal("selectedSelf")
func onChosenAttack(index:int):
	attackSelected = attacks.values()[index]
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
			if attackSelected.type == Enum.AbilityType.EFFECT:
				applyEffect(attackSelected.effectRes)
#			elif attackSelected.type == Enum.AbilityType.EFFECT:
#				pass
			emit_signal("selectedSelf")
func getRandomAttack() -> Ability:
	var availableAtk = []
	for attackName in attacks:
		var attack = attacks[attackName]
		if attack.currentCooldown <= 0 :
			availableAtk.append(attack)
	for attackName in attacks:
		var attackCd = attacks[attackName].currentCooldown
	var keys = attacks.keys()
	var randomAtk = availableAtk.pick_random()
	randomAtk.currentCooldown = randomAtk.cooldown
	return randomAtk
func enemyChooseTarget(nmbOfTargetOfAttack:int):
	var unitSelectable = turnManager.playerPartyManager.currentlyAliveCharacters.duplicate()
	var nmbOfAvailableTargets = min(nmbOfTargetOfAttack, unitSelectable.size())
	print("Enemy select ", nmbOfAvailableTargets, " targets")
	for i in range(nmbOfAvailableTargets):
		target = unitSelectable.pick_random()
		print("Enemy ",self.stats.characterName, " selected ", target.stats.characterName)
		if attackSelected.needToMove:
			getInPosition(target)
		else:
			attack(target, attackSelected)
		unitSelectable.erase(target)

func getInPosition(enemy:BaseUnitScript):
	target = enemy
	setState("getinposition")
func heal():
	pass
func attack(enemy:BaseUnitScript,attack:Ability):
	setState("attacking")
	if attack.hasProjectile:
		spawnVisuals(attack.visual,enemy)
	var attackName:String = attackSelected.attackName
	if attacks[attackName]["cooldown"] >  0:
		var cooldown:int = attacks[attackName]["cooldown"]
		print(attackName, " goes on a ", cooldown, " turn cooldown")
		attacks[attackName]["currentCooldown"] = cooldown
		attacks[attackName]["justUsed"] = true
	match attack.type:
		Enum.AbilityType.ATTACK:
			if attack.statusEffect != Enum.StatusEffect.NONE:
				if attack.effectRes.target != Enum.FocusType.SELF:
					enemy.applyEffect(attack.effectRes)
				else:
					applyEffect(attack.effectRes)
			var atkStat = stats.atk
			var damageOutput:int = atkStat + attack.damage
			enemy.receiveDamage(self,attack,damageOutput)
			if attack.focusType == Enum.FocusType.ENEMY_AOE:
				for ally in enemy.partyManager.currentlyAliveCharacters:
					if ally != target:
						var splashDamage = attack.splashDamage + atkStat
						ally.receiveDamage(self,attack,splashDamage)
						print(ally.stats.characterName, " received ", (attack.splashDamage + stats.atk), " of splash damage")
						print(ally, " stats after AOE: ", ally.getUnitInfo())
		Enum.AbilityType.EFFECT:
			enemy.applyEffect(attack.effectRes)
func attackFinished():
	if self.global_position != self.startingPosition:
		setState("walkingback")
	else:
		setState("endingturn")
func endingTurn():
	print(stats.characterName," end its turn")
	setState("idle")
	emit_signal("turnFinished")

#UI & SELECTION
func isSelectable():
	canBeSelected = true
	area.monitoring = true
func endSelection():
	canBeSelected = false
func onMouseEntered():
	print(getUnitInfo())
	if canBeSelected:
		emit_signal("hovered", self)
	else:
		return
func onMouseExited():
	emit_signal("unhovered", self)
func onArea2DInputEvent(viewport, event, shape_idx):
	if not canBeSelected:
		return
	if event is InputEventMouseButton and event.pressed and isSelectingToSummon:
		emit_signal("selectedForSummon", stats)
	elif event is InputEventMouseButton and event.pressed:
		emit_signal("clickedOn", self)

#UTILS
func setState(newState:String):
	stateMachine.setState(states[newState])
func getUnitInfo():
	var effectSummaries = []
	for effect in activeEffects:
		var effectSummary = {}
		effectSummary["name"] = effect.name
		effectSummary["amount"] = effect.amount if "amount" in effect else ""
		effectSummary["duration"] = effect.duration
		effectSummaries.append(effectSummary)
	return {
		"Name": stats.characterName,
		"Stats": {
			"currentHp": stats.currentHp,
			"atk":stats.atk,
			"deff":stats.deff,
			"speed":stats.speed
		},
		"Active effects": effectSummaries
	}
func reduceTimers():
	for i in range(activeEffects.size() - 1, -1, -1):
		var effect = activeEffects[i]
		effect["duration"] -= 1
		if effect["duration"] <= 0:
			match effect.type:
				Enum.StatusEffect.INVULNERABLE:
					isInvulnerable = false
					var spell = get_node("ShieldEffect")
					spell.exit()
				Enum.StatusEffect.STAT_MODIFIER:
					for statAffected in effect.statsAffected:
						stats.set(
							statAffected,
							stats.get(statAffected) - effect.amountAppliedToUnit
						)
			activeEffects.remove_at(i)
	for attack in attacks:
		if attacks[attack]["currentCooldown"] > 0 and not attacks[attack]["justUsed"]:
			attacks[attack]["currentCooldown"] -= 1
			print("attack: ", attack," cd = ", attacks[attack]["currentCooldown"])
		attacks[attack]["justUsed"] = false
func resetAllStatsBesideHp():
	stats.atk = stats.baseAtk
	stats.deff = stats.baseDeff
	stats.speed = stats.baseSpeed
func linkToFactionParty():
	if faction == Enum.Faction.PLAYER:
		partyManager = get_tree().get_first_node_in_group("player party manager")
	else:
		partyManager = get_tree().get_first_node_in_group("enemy party manager")

