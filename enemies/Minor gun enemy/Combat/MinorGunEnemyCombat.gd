extends Node2D

@onready var anim = $SpritePivot/AnimatedSprite2D

#Stats
@export var hp = 100
@export var attackPower = 5
#Properties
var combatScene 
var isWalking = false
var startingPosition: Vector2
const walkSpeed = 80
var currentState
enum State{
	IDLE,
	WALK_IN,
	ATTACK
}


# Called when the node enters the scene tree for the first time.
func _ready():
	enterState(State.IDLE)
	$SpritePivot.scale.x = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkIfWalkIn(delta)
	updateAnimation()


#ANIMATIONS HANDLERS
func updateAnimation():
	match currentState:
		State.IDLE:
			anim.play("idle")
		State.ATTACK:
			anim.play("attack")
		State.WALK_IN:
			anim.play("walk")


#STATE HANDLERS
func setState(newState:State):
	if currentState == newState:
		return
	currentState = newState
	#print(State.keys()[currentState])
	enterState(newState)
func enterState(newState:State):
	setState(newState)
	match newState:
		State.WALK_IN:
			isWalking = true
		State.IDLE:
			pass
func exitState():
	pass


#BEHAVIORS
func intro(target:Node2D):
	startingPosition = target.global_position
	setState(State.WALK_IN)

func walk(delta):
	global_position = global_position.move_toward(startingPosition, walkSpeed*delta)
	if global_position == startingPosition:
		isWalking = false
		enterState(State.IDLE)


#CHECKS
func checkIfWalkIn(delta):
	if not isWalking:
		return
	walk(delta)
