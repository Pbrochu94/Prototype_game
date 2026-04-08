extends Node2D


@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var enemy = get_tree().get_nodes_in_group("enemy")
#STATS
@export var hp = 100
@export var attackPower = 10
@export var weponEquipped = "sword"
#PARAMETERS
signal introFinished
var currentCombatScene:Node2D


var isWalking = false
const walkSpeed = 80

var currentState:State = State.IDLE
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
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.WALK_IN:
			isWalking = true
			walk(delta, currentCombatScene.playerStartingPosition)
		State.IDLE:
			pass
	updateAnimation()


#CHECKS


#STATES HANDLERS
func setState(newState:State):
	if currentState == newState:
		return
	exitState(currentState)
	currentState = newState
	enterState(newState)
func enterState(newState:State):
	match newState:
		State.WALK_IN:
			isWalking = true
		State.IDLE:
			pass
func exitState(state:State):
	match state:
		State.WALK_IN:
			emit_signal("introFinished")


#ANIMATIONS HANDLERS
func updateAnimation():
	match currentState:
		State.IDLE:
			anim.play("idle")
		State.ATTACK:
			anim.play("attack")
		State.WALK_IN:
			anim.play("walk_in")


#BEHAVIORS
func playIntroWalk(walkTarget:Vector2):
	setState(State.WALK_IN)
func chooseAction():
	currentCombatScene.combatMenu.visible = true
	print("Player is choosing...")
func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	if global_position == destination:
		isWalking = false
		setState(State.IDLE)
func attack(weapon):
	print("ATTACK")
	chooseTarget()
func chooseTarget():
	pass
