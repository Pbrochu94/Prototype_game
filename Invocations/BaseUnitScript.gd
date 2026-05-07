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
@export var faction:Faction

#STATS
@export var characterName:String 
@export var walkSpeed:int
@export var maxHp:int 
@export var currentHp:int 
@export var speed:int 
@export var attacks:Dictionary = {}
@export var attackSelected:Ability

#ENUMS
enum Faction {
	ENEMY,
	SUMMON,
}
enum AttackType{
	ATTACK,
	HEAL,
	SELFHEAL,
	BUFF,
	DEBUFF
}

#STATUS
var isDead:bool = false

#SIGNALS
signal introFinished
signal inPositionToAttack(enemy:Node2D)
signal selectionCompleted
signal dealDamage(amount:int)
signal turnFinished
signal attackChosen
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
	connectSignals()

#ANIMATIONS & SPRITES
func onAnimationFinished():
	match currentState:
		"attacking":
			if anim.animation == attackSelected.attackName:
				stateMachine.setState(stateMachine.states["walkingback"])
		"hurt":
			if anim.animation == "hurt":
				if currentHp <= 0:
					stateMachine.setState(stateMachine.states["downed"])
				else:
					stateMachine.setState(stateMachine.states["idle"])
		"heal":
			if anim.animation == attackSelected.attackName:
				stateMachine.setState(stateMachine.states["endingturn"])
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
	if stateMachine.currentState == stateMachine.states["getinposition"]:
		if global_position == destination:
			isWalking = false
			emit_signal("inPositionToAttack", target)
			attack(target, attackSelected)
	else:
		if global_position == destination:
			stateMachine.setState(stateMachine.states["endingturn"])
			isWalking = false
func receiveDamage(attack:Ability, element:String):
	stateMachine.setState(stateMachine.states["hurt"])
	currentHp-= attack.damage
	print(characterName," now have ", currentHp, " hp ")

#TURN FLOW
func enemyStartTurn():
	print(characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(characterName, " chose the attack: ", attackSelected.attackName)
	match attackSelected.type:
		AttackType.ATTACK:
			enemyChooseTarget()
			emit_signal("donePreparing")
		AttackType.SELFHEAL:
			stateMachine.setState(stateMachine.states["heal"])

func chooseAttack():
	attackSelected = getRandomAttack()
	print("Attack chosen: ", attackSelected.attackName)
	#When we will actually choose
#	if action == "attack":
#		attackSelected = attacks["swordSlash1"]
#	else:
#		return
	match attackSelected.type:
		AttackType.ATTACK:
			emit_signal("attackChosen")
		AttackType.SELFHEAL:
			stateMachine.setState(stateMachine.states["heal"])

func enemyChooseTarget():
	target = currentCombatScene.playerPartyManager.currentlyAliveCharacters.pick_random()
	print("Chosen target: ", target)
func getRandomAttack() -> Ability:
	var keys = attacks.keys()
	var random_key = keys[randi() % keys.size()]
	return attacks[random_key]
func getInPosition():
	if faction == Faction.SUMMON:
		emit_signal("selectionCompleted")
	stateMachine.setState(stateMachine.states["getinposition"])
func attack(enemyTarget:Node2D,weapon):
	stateMachine.setState(stateMachine.states["attacking"])
	print("Player Attacked: ", target.name)
func attackFinished():
	print("Attack finished")
	if self.global_position != self.startingPosition:
		stateMachine.setState(stateMachine.states["walkingback"])
	else:
		stateMachine.setState(stateMachine.states["endingturn"])
func endingTurn():
	print("Player end turn")
	stateMachine.setState(stateMachine.states["idle"])
	emit_signal("turnFinished")

#UI & SELECTION
func isSelectable():
	canBeSelected = true
	area.monitoring = true
	print("Player selection started")
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
		"Speed": speed
	}
