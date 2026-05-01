extends Node2D
class_name InvocationCombat

#NODES
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var startingPosition:Vector2
@onready var hitboxShape = $Hitbox/CollisionShape2D
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 
@onready var spriteOrientation:Node2D = $SpritePivot
var target:Node2D

#VARIABLES
var isWalking:bool = false
var direction:int
var currentState:String

#STATS
@export var characterName:String = ""
@export var walkSpeed:int = 200
@export var maxHp:int = 100
@export var currentHp:int = 100
@export var speed:int = 1
@export var attacks:Dictionary = {
#	"sword slash" : preload("res://Invocations/Samurai/SwordSlash.tres")
}
@export var attackSelected:Attack

#STATUS
var isDead:bool = false

#SIGNALS
signal introFinished
signal inPositionToAttack(enemy:Node2D)
signal selectionEnded
signal dealDamage(amount:int)
signal turnFinished
signal attackChosen
signal hpChanged(currentHp, maxHp)
signal isDowned(character)

# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize state machine on this character
	stateMachine.init(self)
	inPositionToAttack.connect(attack)
	anim.animation_finished.connect(onAnimationFinished)

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
	#Walk to enemy but leave spaces between
	if stateMachine.currentState == stateMachine.states["getinposition"]:
		var stopDistance = 32
		if global_position.distance_to(destination)<= stopDistance:
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
func chooseAttack():
	attackSelected = attacks.get("sword slash")
	print("Attack chosen: ", attackSelected)
	#When we will actually choose
#	if action == "attack":
#		attackSelected = attacks["swordSlash1"]
#	else:
#		return
	emit_signal("attackChosen")
func walkToTarget():
	emit_signal("selectionEnded")
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
