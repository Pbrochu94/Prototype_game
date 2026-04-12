extends Node2D

@onready var anim = $SpritePivot/AnimatedSprite2D

#STATS
@export var hp:int = 100
@export var attackPower:int = 5

#ENVIRONMENTS
var turnManager:Node
var currentCombatScene:Node2D

#PROPERTIES
@onready var area = $Area2D
@onready var selectingArrow = $SelectingArrow
#@onready var arrow = $ArrowIndicator
var isWalking = false
var walkTarget:Vector2
const walkSpeed = 80
var currentState:State
var canBeSelected = false

#ENUMS
enum State{
	IDLE,
	WALK_IN,
	ATTACK
}

#SIGNALS
signal introFinished
signal enemySelected(enemy:Node2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	setState(State.WALK_IN)
	#Instanciate environments
	currentCombatScene = get_tree().get_first_node_in_group("combat scene") 
	turnManager = get_tree().get_first_node_in_group("turn manager")
	#connecting signals
	turnManager.connect("selectionStarted", selectionStarted)
	turnManager.connect("selectionEnded", selectionEnded)
	#Hidding UI
	selectingArrow.visible = false
	#Change his facing side
	$SpritePivot.scale.x = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.WALK_IN:
			isWalking = true
			walk(delta, currentCombatScene.enemyStartingPosition)
		State.IDLE:
			pass


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
	match newState:
		State.WALK_IN:
			isWalking = true
		State.IDLE:
			pass
	updateAnimation()
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

func selectionStarted():
	canBeSelected = true
	area.monitoring = true
	print("selection started")

func selectionEnded():
	print("Selection ended")

#CHECKS

func onArea2DInputEvent(viewport, event, shape_idx):
	if not canBeSelected:
		return
	if event is InputEventMouseButton and event.pressed:
		emit_signal("enemySelected",self)


func onMouseEntered():
	if(canBeSelected):
		selectingArrow.visible = true
	else:
		return


func onMouseExited():
	if(canBeSelected):
		selectingArrow.visible = false
	else:
		return
