extends Node2D

@export var hp = 100
@export var attackPower = 10
@export var weponEquipped = "sword"
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var actionsUI = $PlayerActionsUI
#@onready var positionTarget = $PlayerAnchor
var isWalking = false
var startingPosition: Vector2
const walkSpeed = 80

var currentState
var direction
enum State {
	WALK_IN,
	IDLE,
	ATTACK,
	DAMAGE,
	DEAD
}
# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = State.IDLE
	setState(State.WALK_IN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkIfWalkIn(delta)
	updateAnimation()


#CHECKS
func checkIfWalkIn(delta):
	if not isWalking:
		return
	walk(delta)


#STATES HANDLERS
func setState(newState:State):
	if currentState == newState:
		return
	currentState = newState
	enterState(newState)

func enterState(newState:State):
	print(State.keys()[currentState])
	match newState:
		State.WALK_IN:
			isWalking = true

func exitState():
	pass


#ANIMATIONS HANDLERS
func updateAnimation():
	match currentState:
		State.IDLE:
			anim.play("idle")
		State.ATTACK:
			anim.play("attack")
		State.WALK_IN:
			anim.play("walk_in")

func intro(target:Node2D):
	print("TAGET POSITION",target.global_position)
	startingPosition = target.global_position
	setState(State.WALK_IN)


#BEHAVIORS
func startTurn():
	print("Player start")
	actionsUI.visible = true

func walk(delta):
	print("walks")
	global_position = global_position.move_toward(startingPosition, walkSpeed*delta)
func attack(weapon):
	pass
