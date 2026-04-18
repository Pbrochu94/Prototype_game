extends Node2D
class_name PlayerCombat

@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var enemy = get_tree().get_nodes_in_group("enemy")
@onready var startingPosition:Vector2
#STATS
@export var characterName = "Artorias"
@export var hp = 100
@export var attacks:Dictionary= {
	"sword slash 1" : swordSlash1
}
@export var attackSelected:Attack

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

var isWalking = false
const walkSpeed = 80

#Preload attacks
const swordSlash1 = preload("res://utils/Attacks/MainCharacter/SwordSlash1.tres")


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
#	match currentState:
#		State.WALK_IN,State.WALK_BACK:
#			isWalking = true
#			walk(delta, currentCombatScene.playerStartingPosition)
#		State.IDLE:
#			pass
#		State.WALK_TO_TARGET:
#			isWalking = true
#			walk(delta, enemyTargeted.global_position)


#CHECKS



#func enterState(newState:State):
#	match newState:
#		State.WALK_IN:
#			isWalking = true
#		State.WALK_TO_TARGET:
#			isWalking = true
#		State.WALK_BACK:
#			isWalking = true
#		State.IDLE:
#			pass
#		State.ATTACK:
#			pass
	#At the start of a state the animation play once (Or on loop if set to loop)
#	updateAnimation()
#func exitState(state:State):
#	match state:
#		State.WALK_IN:
#			emit_signal("introFinished")
#			isWalking = false
#		State.WALK_TO_TARGET:
#			isWalking = false
#		State.WALK_BACK:
#			isWalking = false
#			emit_signal("turnFinished")
#		State.ATTACK:
#			pass


#ANIMATIONS HANDLERS
#func updateAnimation():
#	match currentState:
#		State.IDLE:
#			anim.play("idle")
#			anim.scale.x = 1
#		State.ATTACK:
#			anim.play("attack")
#		State.WALK_IN,State.WALK_TO_TARGET:
#			anim.play("walk")
#		State.WALK_BACK:
#			#Flip sprite when walking back
#			anim.scale.x = -1
#			anim.play("walk")

func onAnimationFinished():
	if anim.animation == "attack":
		stateMachine.setState(stateMachine.states["walkingback"])

#BEHAVIORS
func playIntroWalk(walkTarget:Vector2):
	stateMachine.setState(stateMachine.states["intro"])

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
			isWalking = false
			onIntroFinished()

func walkToTarget():
	emit_signal("selectionEnded")
	stateMachine.setState(stateMachine.states["getinposition"])

func chooseAttack():
	print(attacks)
	attackSelected = attacks["sword slash 1"]
	print("Attack chosen: ", attackSelected)
	#When we will actually choose
#	if action == "attack":
#		attackSelected = attacks["swordSlash1"]
#	else:
#		return
	emit_signal("attackChosen")

func attack(enemyTarget:Node2D,weapon):
	stateMachine.setState(stateMachine.states["attacking"])
	print("Player Attacked: ", target.name)

func onIntroFinished():
	stateMachine.setState(stateMachine.states["idle"])
	emit_signal("introFinished")

func endingTurn():
	emit_signal("turnFinished")
	stateMachine.setState(stateMachine.states["endingturn"])

func addNewWeapon(filePath:String):
	var attack = load(filePath) as Attack
	attacks[attack.attackName] = attack
	if attack == null:
		push_error("Failed to load attack: " + filePath)
		return
