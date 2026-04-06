extends Node2D


@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var actionsUI = $PlayerActionsUI
@onready var enemy = get_tree().get_nodes_in_group("enemy")
#STATS
@export var hp = 100
@export var attackPower = 10
@export var weponEquipped = "sword"
#PARAMETERS
var walkTarget:Vector2
signal introFinished


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
	setState(State.WALK_IN)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walk(delta)
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
			actionsUI.visible = true
func exitState(state:State):
	match state:
		State.WALK_IN:
			print("EXCITT")
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
func chooseAction():
	print("Player is choosing...")
func walk(delta):
	if not isWalking:
		return
	global_position = global_position.move_toward(walkTarget, walkSpeed*delta)
	if global_position == walkTarget:
		isWalking = false
		setState(State.IDLE)
func attack(weapon):
	print("ATTACK")
	chooseTarget()
func chooseTarget():
	pass
