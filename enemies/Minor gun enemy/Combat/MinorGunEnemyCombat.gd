extends Node2D

@onready var anim = $SpritePivot/AnimatedSprite2D

#Stats
@export var hp:int = 100
@export var attackPower:int = 5
#Properties
signal introFinished
var currentCombatScene:Node2D
var isWalking = false
var walkTarget:Vector2
const walkSpeed = 80
var currentState:State
enum State{
	IDLE,
	WALK_IN,
	ATTACK
}


# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = State.WALK_IN
	currentCombatScene = get_tree().get_first_node_in_group("combat scene") 
	$SpritePivot.scale.x = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.WALK_IN:
			isWalking = true
			walk(delta, currentCombatScene.enemyStartingPosition)
		State.IDLE:
			pass
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
func exitState(state:State):
	match state:
		State.WALK_IN:
			emit_signal("introFinished")


#BEHAVIORS
func playIntroWalk(walkTarget:Vector2):
	setState(State.WALK_IN)

func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	if global_position == destination:
		isWalking = false
		setState(State.IDLE)


#CHECKS

