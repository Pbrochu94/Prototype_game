extends Node2D

#NODES STORING
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var spriteOrientation = $SpritePivot

#STATS
@export var hp:int = 100
@export var attackPower:int = 5
@export var characterName = "Gunny"

var attacks:Array[Attack] = [
	Attack.new("melee hit", 10),
	Attack.new("gun shot", 50),
]

#ENVIRONMENTS
var turnManager:Node
var currentCombatScene:Node2D


#PROPERTIES
@onready var area = $Area2D
@onready var selectingArrow = $SelectingArrow
var isWalking = false
var walkTarget:Vector2
const walkSpeed = 80
var currentState:State
var canBeSelected = false
var characterTargeting:Node2D
var attackUsed:Attack
var facingPlayer:int = -1
var facingBackward:int = 1

#ENUMS
enum State{
	IDLE,
	WALK_IN,
	WALK_TO_TARGET,
	WALK_BACK,
	ATTACK,
	HURT
}

#SIGNALS
signal introFinished
signal enemySelected(enemy:Node2D)
signal donePreparing
signal inPositionToAttack
signal turnFinished

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	setState(State.WALK_IN)
	#Instanciate environments
	currentCombatScene = get_tree().get_first_node_in_group("combat scene") 
	turnManager = get_tree().get_first_node_in_group("turn manager")
	#connecting signals
	anim.animation_finished.connect(onAnimationFinished)
	turnManager.connect("selectionStarted", selectionStarted)
	turnManager.connect("selectionEnded", selectionEnded)
	currentCombatScene.player.connect("dealDamage", receiveDamage)
	#Hidding UI
	selectingArrow.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.IDLE:
			pass
		State.WALK_IN,State.WALK_BACK:
			walk(delta, currentCombatScene.enemyStartingPosition)
		State.WALK_TO_TARGET:
			walk(delta, characterTargeting.global_position)



#ANIMATIONS HANDLERS
func updateAnimation():
	match currentState:
		State.IDLE:
			anim.play("idle")
			orientSprite(facingPlayer)
		State.WALK_IN, State.WALK_TO_TARGET:
			orientSprite(facingPlayer)
			anim.play("walk")
		State.WALK_BACK:
			anim.play("walk")
			orientSprite(facingBackward)
		State.ATTACK:
			if attackUsed.name == "melee hit":
				anim.play("attack melee")
			if attackUsed.name == "gun shot":
				anim.play("attack gun")
		State.HURT:
			anim.play("hurt")

func onAnimationFinished():
	if anim.animation == "hurt":
		setState(State.IDLE)
	if anim.animation == "attack melee":
		setState(State.WALK_BACK)
	if anim.animation == "attack gun":
		setState(State.IDLE)

func orientSprite(direction:int):
	spriteOrientation.scale.x = direction

#STATE HANDLERS
func setState(newState:State):
	if currentState == newState:
		return
	exitState(currentState)
	currentState = newState
	enterState(newState)
func enterState(newState:State):
	match newState:
		State.IDLE:
			pass
		State.WALK_IN,State.WALK_TO_TARGET,State.WALK_BACK:
			isWalking = true
		State.HURT:
			pass
		State.ATTACK:
			pass
	updateAnimation()
func exitState(state:State):
	match state:
		State.WALK_IN:
			emit_signal("introFinished")
		State.WALK_BACK:
				orientSprite(facingPlayer)
				emit_signal("turnFinished")


#BEHAVIORS
func playIntroWalk(walkTarget:Vector2):
	setState(State.WALK_IN)

func startTurn():
	print(characterName, " started his turn")
	#Choose character to attack
	characterTargeting = currentCombatScene.player
	#Choose weapon to attack
	attackUsed = attacks.pick_random()
	emit_signal("donePreparing")

func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	#Walk to character but leave spaces between
	if currentState == State.WALK_TO_TARGET:
		var stopDistance = 32
		if global_position.distance_to(destination)<= stopDistance:
			isWalking = false
			emit_signal("inPositionToAttack")
	else:
		if global_position == destination:
			isWalking = false
			setState(State.IDLE)

func getInPosition():
	print("Enemy gets in position")
	if attackUsed.name == "melee hit":
		setState(State.WALK_TO_TARGET)
	if attackUsed.name == "gun shot":
		emit_signal("inPositionToAttack")

func endTurn():
	emit_signal("turnFinished")

func attack():
	print("enemy attacks: ", characterTargeting.characterName, " with ", attackUsed.name, " for ", attackUsed.damage)
	setState(State.ATTACK)

func receiveDamage(amount:int):
	setState(State.HURT)
	print("enemy", self, " receive ", amount, " of damage")
	hp-= amount
	print("After hit: ", hp)

func selectionStarted():
	canBeSelected = true
	area.monitoring = true
	print("Player selection started")

func selectionEnded():
	print("Player selection ended")
	selectingArrow.visible = false
	canBeSelected = false

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
	selectingArrow.visible = false


