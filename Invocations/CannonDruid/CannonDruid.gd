extends Node2D
class_name CannonDruidCombat

#NODES STORING
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var spriteOrientation = $SpritePivot
@onready var stateMachine = $StateMachine
@onready var area = $Area2D
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 

#STATS
@export var maxHp = 100
@export var currentHp = 100
@export var attackPower:int = 5
@export var characterName = "Cannon Druid"
@export var speed = 2
@export var walkSpeed = 200
#ATTACKS & SPELLS
@export var attacks:Dictionary = {
	"cannon shot" : preload("res://Invocations/CannonDruid/Attacks/Cannonshot.tres")
}
#STATUS
var isDead = false

#VARIABLES
var startingPosition
var isWalking = false
var walkTarget:Vector2

var currentState:String
var canBeSelected = false
var target:Node2D
var attackSelected:Attack
var facingPlayer:int = -1
var facingBackward:int = 1

#ENUMS
enum State{
	IDLE,
	WALK_IN,
	WALK_TO_TARGET,
	WALK_BACK,
	ATTACK,
	HURT
}

#SIGNALS
signal introFinished
signal enemySelected(enemy:Node2D)
signal donePreparing
signal inPositionToAttack
signal turnFinished
signal hpChanged(currentHp, maxHp)
signal isDowned(character)
signal hovered(character)
signal unhovered(character)

# Called when the node enters the scene tree for the first time.
func _ready():
	orientSprite(facingPlayer)
	#Initialize State machine
	stateMachine.init(self)
	#connecting signals
	connectSignals()

#INIT
func connectSignals():
	anim.animation_finished.connect(onAnimationFinished)
	turnManager.targetSelectionStarted.connect(isSelectable)

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
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction

#BEHAVIORS
func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	#Walk to character but leave spaces between
	if stateMachine.currentState == stateMachine.states["getinposition"]:
		var stopDistance = 32
		if global_position.distance_to(destination)<= stopDistance:
			isWalking = false
			emit_signal("inPositionToAttack", target)
			attack()
	else:
		if global_position == destination:
			stateMachine.setState(stateMachine.states["endingturn"])
			isWalking = false
func receiveDamage(attack:Attack, element:String):
	stateMachine.setState(stateMachine.states["hurt"])
	print(self.characterName, " receive ", attack.damage, " of ", element," damage")
	currentHp-= attack.damage
	emit_signal("hpChanged")
	print("After hit: ", currentHp)

#TURN FLOW
func startTurn():
	print(characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(characterName, " chose the attack: ", attackSelected.attackName)
	chooseTarget()
	emit_signal("donePreparing")
func chooseTarget():
	target = currentCombatScene.playerPartyManager.currentlyAliveCharacters.pick_random()
	print("Chosen target: ", target)
func getRandomAttack() -> Attack:
	var keys = attacks.keys()
	var random_key = keys[randi() % keys.size()]
	return attacks[random_key]
func getInPosition():
	print("Enemy gets in position")
	if attackSelected.attackName == "cannon shot":
		stateMachine.setState(stateMachine.states["getinposition"])
#	if attackSelected.attackName == "gun shot":
#		stateMachine.setState(stateMachine.states["attacking"])
func attack():
	stateMachine.setState(stateMachine.states["attacking"])
	print("Enemy Attacked: ", target.name)
func attackFinished():
	print("Attack finished")
	if self.global_position != self.startingPosition:
		stateMachine.setState(stateMachine.states["walkingback"])
	else:
		stateMachine.setState(stateMachine.states["endingturn"])
func endingTurn():
	print(characterName, "finished its turn")
	stateMachine.setState(stateMachine.states["idle"])
	emit_signal("turnFinished")


#UI & SELECTION
func isSelectable():
	canBeSelected = true
	area.monitoring = true
	print("Player selection started")
func selectionEnded():
	canBeSelected = false

#AREA SIGNALS
func onArea2DInputEvent(viewport, event, shape_idx):
	if not canBeSelected:
		return
	if event is InputEventMouseButton and event.pressed:
		emit_signal("enemySelected",self)
func onMouseEntered():
	print("AHHHHH")
	if not isDead and canBeSelected:
		emit_signal("hovered", self)
	else:
		return
func onMouseExited():
	emit_signal("unhovered", self)
