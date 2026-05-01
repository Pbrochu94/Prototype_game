extends Node2D
class_name BlasterDruidCombat

@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var enemy = get_tree().get_nodes_in_group("enemy")
@onready var startingPosition:Vector2
@onready var hitboxShape = $Hitbox/CollisionShape2D
@onready var spriteOrientation = $SpritePivot
#STATS
@export var characterName = "Blaster druid"
@export var maxHp = 100
@export var currentHp = 100
@export var speed = 3
@export var attacks = [
	preload("res://Invocations/BlasterDruid/GunShot.tres")
]
@export var attackSelected:Attack
@export var walkSpeed = 80

#BOOLEANS
var isWalking = false

#PARAMETERS
var currentCombatScene:Node2D
var target:Node2D


#SIGNALS
signal introFinished
signal inPositionToAttack(enemy:Node2D)
signal selectionEnded
signal dealDamage(amount:int)
signal turnFinished
signal attackChosen
signal hpChanged(currentHp, maxHp)
signal isDowned



var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	#Initialize state machine on this character
	stateMachine.init(self)
	inPositionToAttack.connect(attack)
	anim.animation_finished.connect(onAnimationFinished)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#ANIMATIONS & SPRITES
func onAnimationFinished():
	if anim.animation == attackSelected.attackName:
		stateMachine.setState(stateMachine.states["walkingback"])
	if anim.animation == "hurt":
		if currentHp <= 0:
			stateMachine.setState(owner.stateMachine.states["downed"])
		else:
			stateMachine.setState(owner.stateMachine.states["idle"])

func attackFinished():
	print("Attack finished")
	if self.global_position != self.startingPosition:
		stateMachine.setState(stateMachine.states["walkingback"])
	else:
		stateMachine.setState(stateMachine.states["endingturn"])

#TURN FLOW
func chooseAttack():
#	print(weapon)
	attackSelected = attacks[0]
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
func endingTurn():
	print("Player end turn")
	stateMachine.setState(stateMachine.states["idle"])
	emit_signal("turnFinished")

#BEHAVIORS
#func playIntroWalk(walkTarget:Vector2):
#	stateMachine.setState(stateMachine.states["intro"])
func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	#Walk to enemy but leave spaces between
	if stateMachine.currentState == stateMachine.states["getinposition"]:
		var stopDistance = 200
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

