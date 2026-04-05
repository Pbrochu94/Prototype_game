extends Node2D


@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var actionsUI = $PlayerActionsUI
@onready var enemy = get_tree().get_nodes_in_group("enemy")
#STATS
@export var hp = 100
@export var attackPower = 10
@export var weponEquipped = "sword"
signal introFinished


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
	#print(State.keys()[currentState])
	enterState(newState)
func enterState(newState:State):
	setState(newState)
	match newState:
		State.WALK_IN:
			isWalking = true
		State.IDLE:
			actionsUI.visible = true
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
	print(target)
	startingPosition = target.global_position
	setState(State.WALK_IN)


#BEHAVIORS
func chooseAction():
	print("Player is choosing...")
func walk(delta):
	global_position = global_position.move_toward(startingPosition, walkSpeed*delta)
	if global_position == startingPosition:
		isWalking = false
		enterState(State.IDLE)
func attack(weapon):
	print("ATTACK")
	chooseTarget()
func chooseTarget():
	pass
