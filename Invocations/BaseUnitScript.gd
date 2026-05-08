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
var target:Node2D

#VARIABLES
var canBeSelected = false
var currentState:String
var isWalking = false
var direction:int
var states:Dictionary
@export var faction:Faction

#STATS
@export var characterName:String 
@export var walkSpeed:int
@export var maxHp:int 
@export var currentHp:int 
@export var speed:int 
@export var attacks:Dictionary = {}
@export var attackSelected:Ability
@export var deff:int
@export var atk:int


#ENUMS
enum Faction {
	ENEMY,
	SUMMON,
}
enum AbilityType{
	ATTACK,
	HEAL,
	SELFHEAL,
	BUFF,
	DEBUFF
}
enum FocusType {
	SELF,
	ENEMY,
	ENEMY_MULTIPLE,
	ALLY,
	ALLY_MULTIPLE,
	AOE
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


# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize state machine on this character
	stateMachine.init(self)
	stateMachine.setState(states["idle"])
	connectSignals()

#ANIMATIONS & SPRITES
func onAnimationFinished():
	match currentState:
		"attacking":
			if anim.animation == attackSelected.attackName:
				stateMachine.setState(states["walkingback"])
		"hurt":
			if anim.animation == "hurt":
				if currentHp <= 0:
					stateMachine.setState(states["downed"])
				else:
					stateMachine.setState(states["idle"])
		"heal":
			if anim.animation == attackSelected.attackName:
				stateMachine.setState(states["endingturn"])
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
			emit_signal("inPositionToAttack", target)
			attack(target, attackSelected)
	else:
		if global_position == destination:
			stateMachine.setState(states["endingturn"])
			isWalking = false
func receiveDamage(damage:int, element:String):
	stateMachine.setState(states["hurt"])
	currentHp-= (damage - deff)
	print(characterName," now have ", currentHp, " hp ")

#TURN FLOW
func enemyStartTurn():
	print(characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(characterName, " chose the attack: ", attackSelected.attackName)
	match attackSelected.focus:
		FocusType.ENEMY, FocusType.AOE:
			emit_signal("donePreparing")
			enemyChooseTarget()
		FocusType.ENEMY_MULTIPLE:
			pass
		FocusType.ALLY:
			#emit_signal(startSelectingAllyTarget)
			pass
		FocusType.ALLY_MULTIPLE:
			#emit_signal(startSelectingAllyTarget)
			pass
		FocusType.SELF:
			target = self
			if attackSelected.type == AbilityType.HEAL:
				stateMachine.setState(states["heal"])
			elif attackSelected.type == AbilityType.BUFF:
				pass
#	match attackSelected.type:
#		AbilityType.ATTACK:
#			enemyChooseTarget()
#			emit_signal("donePreparing")
#		AbilityType.HEAL:
#			stateMachine.setState(states["heal"])

func onChosenAttack(index:int):
	attackSelected = attacks.values()[index]
	print("Attack selected: ", attackSelected)
	print("Focus type : ",attackSelected.FocusType.keys()[attackSelected.focus])
	match attackSelected.focus:
		FocusType.ENEMY, FocusType.AOE:
			emit_signal("startSelectingEnemyTarget", attackSelected.focus)
		FocusType.ENEMY_MULTIPLE:
			emit_signal("startSelectingEnemyTarget", attackSelected.focus)
		FocusType.ALLY:
			#emit_signal(startSelectingAllyTarget)
			pass
		FocusType.ALLY_MULTIPLE:
			#emit_signal(startSelectingAllyTarget)
			pass
		FocusType.SELF:
			target = self
			if attackSelected.type == AbilityType.HEAL:
				stateMachine.setState(states["heal"])
			elif attackSelected.type == AbilityType.BUFF:
				pass
			emit_signal("selectedSelf")

func enemyChooseTarget():
	target = currentCombatScene.playerPartyManager.currentlyAliveCharacters.pick_random()
	print("Chosen target: ", target)
func getRandomAttack() -> Ability:
	var keys = attacks.keys()
	var random_key = keys[randi() % keys.size()]
	return attacks[random_key]
func getInPosition():
	if faction == Faction.SUMMON:
		emit_signal("stopSelectingTarget")
	stateMachine.setState(states["getinposition"])
func attack(enemyTarget:Node2D,weapon):
	stateMachine.setState(states["attacking"])
	print("Player Attacked: ", target.name)
func attackFinished():
	print("Attack finished")
	if self.global_position != self.startingPosition:
		stateMachine.setState(states["walkingback"])
	else:
		stateMachine.setState(states["endingturn"])
func endingTurn():
	print("Player end turn")
	stateMachine.setState(states["idle"])
	emit_signal("turnFinished")

#UI & SELECTION
func isSelectable():
	canBeSelected = true
	area.monitoring = true
func selectionEnded():
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
		emit_signal("enemySelected",self)

#INFO
func getUnitInfo():
	return {
		"Name": characterName,
		"Walk speed" : walkSpeed,
		"Max HP": maxHp,
		"Current HP": currentHp,
		"Speed": speed,
		"Deff": deff,
		"Attack": atk
	}
