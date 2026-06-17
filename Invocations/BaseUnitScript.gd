extends Node2D
class_name BaseUnitScript

#NODES
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var shaderMaterial := anim.material as ShaderMaterial
@onready var stateMachine = $StateMachine
@onready var startingPosition:Vector2
@onready var hitboxShape = $Hitbox/CollisionShape2D
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 
@onready var spriteOrientation:Node2D = $SpritePivot
@onready var area = $Area2D
@export var faction:Enum.Faction
@export var element:Enum.Element
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
@export var definition : UnitDefinition
@export var stats : UnitInstance
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
signal selectedForSummon(unit:UnitInstance)


# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize state machine on this character
	stateMachine.init(self)
	setState("idle")
	connectSignals()
	linkToFactionParty()

#ANIMATIONS/VISUALS & SPRITES ----------------------------------------------------------------------
func onAnimationFinished():
	match currentState:
		"attacking":
#			if anim.animation == attackSelected.attackName:
			if attackSelected.needToMove and !isDead:
				setState("walkingback")
			elif !attackSelected.needToMove and !isDead:
				setState("idle")
				setState("endingturn")
		"heal":
			if anim.animation == attackSelected.attackName:
				setState("endingturn")
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction
	z_index = 1
func spawnVisuals(visual:PackedScene,target:BaseUnitScript):
	target.add_child(visual.instantiate())
func hurtFlash()-> Tween:
	match stats.element:
		Enum.Element.WHITE:
			shaderMaterial.set_shader_parameter("flash_color", Vector3(1, 1, 1)) # Blanc
			var tween = create_tween()
		# Montée rapide
			tween.set_trans(Tween.TRANS_EXPO)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 1.0, 0.02)
		# Descente plus douce
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 0.0, 0.20)
			return tween
		Enum.Element.RED:
			shaderMaterial.set_shader_parameter("flash_color", Vector3(1.0, 0.2, 0.0)) # Rouge
			var tween = create_tween()
		# Montée rapide
			tween.set_trans(Tween.TRANS_EXPO)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 1.0, 0.02)
		# Descente plus douce
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 0.0, 0.20)
			return tween
		_: # Blanc par default
			shaderMaterial.set_shader_parameter("flash_color", Vector3(1, 1, 1)) # Blanc
			var tween = create_tween()
		# Montée rapide
			tween.set_trans(Tween.TRANS_EXPO)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 1.0, 0.02)
		# Descente plus douce
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 0.0, 0.20)
			return tween
func healFlash()-> Tween:
	shaderMaterial.set_shader_parameter("flash_color", Vector3(0, 1, 0)) # vert
	var tween = create_tween()
	# Montée douce
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 1.0, 0.35)
	# Descente douce
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shaderMaterial, "shader_parameter/flash_amount", 0.0, 0.35)
	return tween
#INIT ----------------------------------------------------------------------------------------------
func connectSignals():
	turnManager.targetSelectionStarted.connect(isSelectable)
	inPositionToAttack.connect(attack)
	anim.animation_finished.connect(onAnimationFinished)

#BASIC BEHAVIORS -----------------------------------------------------------------------------------------
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

#ENEMY SPECIFIC ACTIONS ------------------------------------------------------------------------------------
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
				anim.play(attackSelected.attackName)
				await anim.animation_finished
				applyEffect(attackSelected.effectRes)
				attackFinished()
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
#ATTACKING -----------------------------------------------------------------------------------------
func onChosenAttack(attack:Ability):
	attackSelected = attack
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
				attack(target,attackSelected)
			emit_signal("selectedSelf")
func getInPosition(enemy:BaseUnitScript):
	target = enemy
	setState("getinposition")
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
			var atkStat = stats.atk
			var damageOutput:int = atkStat + attack.damage
			enemy.receiveDamage(self,attack,damageOutput)
			if attack.effectRes:
				if attack.effectRes.target == Enum.FocusType.SELF:
					applyEffect(attack.effectRes)
				else:
					enemy.applyEffect(attack.effectRes)
			if attack.focusType == Enum.FocusType.ENEMY_AOE:
				for ally in enemy.partyManager.currentlyAliveCharacters:
					if ally != target:
						var splashDamage = attack.splashDamage + atkStat
						ally.receiveDamage(self,attack,splashDamage)
						print(ally.stats.characterName, " received ", (attack.splashDamage + stats.atk), " of splash damage")
						print(ally, " stats after AOE: ", ally.getUnitInfo())
			if enemy.hasRetaliation:
				receiveRetaliationDamage(enemy)
		Enum.AbilityType.EFFECT:
			enemy.applyEffect(attack.effectRes)
func attackFinished():
	if self.global_position != self.startingPosition:
		setState("walkingback")
	else:
		setState("endingturn")
# EFFECTS & SUPPORTS
func applyEffect(effect:Effect):
	print(effect.name, " is applied to: ", self)
	var effectApplied = effect.duplicate(true)
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
				effectApplied.digitAmount = modifier
				stats.set(
					statAffected,
					stats.get(statAffected) + modifier
				)
				print(stats.characterName, " received the effect ", effectApplied.name)
				activeEffects.append(effectApplied)
		Enum.StatusEffect.HEAL:
				heal(attackSelected)
		Enum.StatusEffect.RETALIATION:
			hasRetaliation = true
			activeEffects.append(effectApplied)
func heal(source):
	print(source)
	if source is ItemData:
		await healFlash().finished
		print(stats.characterName," hp BEFORE heal: ",stats.currentHp)
		stats.currentHp += source.amount
		if stats.currentHp > stats.maxHp:
			stats.currentHp = stats.maxHp
		print(stats.characterName," hp AFTER heal: ",stats.currentHp)
	elif source is Ability:
		var attackName = source.attackName
		if source.focusType == Enum.FocusType.SELF:
			target.anim.play(attackSelected.attackName.to_lower())
		else:
			target = owner.target
			await target.healFlash().finished
		print(target.stats.characterName," hp BEFORE heal: ",target.stats.currentHp)
		target.stats.currentHp += attackSelected.effectRes.amount
		if target.stats.currentHp > target.stats.maxHp:
			target.stats.currentHp = target.stats.maxHp
		print(target.stats.characterName," hp AFTER heal: ",target.stats.currentHp)
#RECEIVING DAMAGE-----------------------------------------------------------------------------------
func receiveDamage(attacker,attack, damage):
	if isInvulnerable:
		negateDamage(attacker)
		return
	var trueDamage:int = damage - stats.deff
	if trueDamage <= 0:
		trueDamage = 0
		print(attacker.stats.characterName, " does no damage to ", stats.characterName)
	else:
		var attackerName = attacker.characterName if attacker is BaseSummonerScript else attacker.stats.characterName
		print(attackerName, " attack ", stats.characterName, " for ", damage, "(damage+atk) ", attack.element, " damage minus ", stats.deff,"(deff) for a total of ",trueDamage)
		print(stats.characterName," has ", stats.currentHp, " hp before attack ")
		stats.currentHp-= trueDamage
		await hurtFlash().finished
		emit_signal("hpChanged")
		checkIfDead()
		print(stats.characterName," now have ", stats.currentHp, " hp after attack ")
func receiveRetaliationDamage(enemy:BaseUnitScript):
	for effect in enemy.activeEffects:
		if effect.name == "retaliation":
			receiveDamage(self,effect,effect.amount)
func negateDamage(attacker:BaseUnitScript):
	if isInvulnerable:
		print(stats.characterName, " is invulnerable and negated the attack from ", attacker)
func checkIfDead():
	if stats.currentHp <= 0:
		isDead = true
		match currentState:
			"attacking":
				await anim.animation_finished
				setState("downed")
				await anim.animation_finished
				emit_signal("turnFinished")
			"idle":
				setState("downed")
#END OF TURN ---------------------------------------------------------------------------------------
func endingTurn():
	print(stats.characterName," end its turn")
	setState("idle")
	emit_signal("turnFinished")
#UI & SELECTION ------------------------------------------------------------------------------------
func isSelectable():
	if not isDead:
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
#UTILS ---------------------------------------------------------------------------------------------
func setState(newState:String):
	stateMachine.setState(states[newState])
func getUnitInfo():
	var effectSummaries = []
	for effect in activeEffects:
		match effect.type:
			Enum.StatusEffect.STAT_MODIFIER:
						var effectSummary:Dictionary
						effectSummary["name"] = effect.name
						effectSummary["amount %"] = effect.amount if "amount" in effect else ""
						effectSummary["amount digit"] = effect.digitAmount
						effectSummary["duration"] = effect.duration
						effectSummaries.append(effectSummary)
			Enum.StatusEffect.RETALIATION:
						var effectSummary:Dictionary
						effectSummary["name"] = effect.name
						effectSummary["amount"] = effect.amount if "amount" in effect else ""
						effectSummary["duration"] = effect.duration
						effectSummaries.append(effectSummary)
			Enum.StatusEffect.INVULNERABLE:
						var effectSummary:Dictionary
						effectSummary["name"] = effect.name
						effectSummary["duration"] = effect.duration
						effectSummaries.append(effectSummary)
		var effectSummary = {}
	return {
		"Name": stats.characterName,
		"Stats": {
			"currentHp": stats.currentHp,
			"atk":stats.atk,
			"deff":stats.deff,
			"speed":stats.speed
		},
		"Active effects": effectSummaries,
#		"State": currentState,
#		"z": z_index
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

