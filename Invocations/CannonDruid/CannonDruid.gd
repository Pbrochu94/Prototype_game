extends Node2D
class_name CannonUnitScript

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
@export var characterName:String = "Cannon druid"
@export var walkSpeed:int = 200
@export var maxHp:int = 100
@export var currentHp:int = 100
@export var speed:int = 1
@export var attacks:Dictionary = {
	"cannon shot" : preload("res://Invocations/CannonDruid/Attacks/Cannonshot.tres"),
	"rebuild": preload("res://Invocations/CannonDruid/Attacks/DruidHeal.tres")
}
@export var attackSelected:Attack

#ENUMS
enum Faction {
	ENEMY,
	SUMMON
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
func receiveDamage(attack:Attack, element:String):
	stateMachine.setState(stateMachine.states["hurt"])
	print(self.characterName, " receive ", attack.damage, " of ", element," damage")
	currentHp-= attack.damage
	print("After hit: ", currentHp)

#TURN FLOW
func enemyStartTurn():
	print(characterName, " started his turn")
	attackSelected = getRandomAttack()
	print(characterName, " chose the attack: ", attackSelected.attackName)
	chooseTarget()
	emit_signal("donePreparing")
func chooseAttack():
	attackSelected = attacks.get("cannon shot")
	print("Attack chosen: ", attackSelected)
	#When we will actually choose
#	if action == "attack":
#		attackSelected = attacks["swordSlash1"]
#	else:
#		return
	emit_signal("attackChosen")
func chooseTarget():
	target = currentCombatScene.playerPartyManager.currentlyAliveCharacters.pick_random()
	print("Chosen target: ", target)
func getRandomAttack() -> Attack:
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
