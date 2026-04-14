extends Node2D

@onready var anim = $SpritePivot/AnimatedSprite2D

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
#@onready var arrow = $ArrowIndicator
var isWalking = false
var walkTarget:Vector2
const walkSpeed = 80
var currentState:State
var canBeSelected = false
var characterTargeting:Node2D
var attackUsed:Attack

#ENUMS
enum State{
	IDLE,
	WALK_IN,
	WALK_TO_TARGET,
	ATTACK,
	HURT
}

#SIGNALS
signal introFinished
signal enemySelected(enemy:Node2D)
signal donePreparing
signal inPositionToAttack

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
	#Change his facing side
	$SpritePivot.scale.x = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match currentState:
		State.IDLE:
			pass
		State.WALK_IN:
			walk(delta, currentCombatScene.enemyStartingPosition)
		State.WALK_TO_TARGET:
			isWalking = true
			walk(delta, characterTargeting.global_position)



#ANIMATIONS HANDLERS
func updateAnimation():
	match currentState:
		State.IDLE:
			anim.play("idle")
		State.WALK_IN, State.WALK_TO_TARGET:
			anim.play("walk")
		State.ATTACK:
			if attackUsed.name == "melee hit":
				anim.play("attack melee")
			if attackUsed.name == "gun shot":
				anim.play("attack gun")
		State.HURT:
			anim.play("hurt")

func onAnimationFinished():
	if anim.animation == "hurt":
#		setState(State.WALK_BACK)
		setState(State.IDLE)

#STATE HANDLERS
func setState(newState:State):
	if currentState == newState:
		return
	currentState = newState
	#print(State.keys()[currentState])
	enterState(newState)
func enterState(newState:State):
	match newState:
		State.IDLE:
			pass
		State.WALK_IN:
			isWalking = true
		State.WALK_TO_TARGET:
			pass
		State.HURT:
			pass
		State.ATTACK:
			pass
	updateAnimation()
func exitState(state:State):
	match state:
		State.WALK_IN:
			emit_signal("introFinished")


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
	print(attackUsed.name)
	if attackUsed.name == "melee hit":
		print("Attack used is melee")
		setState(State.WALK_TO_TARGET)
	if attackUsed.name == "gun shot":
		print("Attack used is gun")
		emit_signal("inPositionToAttack")

func attack():
	print("enemy attacks: ", characterTargeting.characterName, " with ", attackUsed.name, " for ", attackUsed.damage)
	setState(State.ATTACK)

func receiveDamage(amount:int):
	setState(State.HURT)
	print("Before hit: ", hp)
	print("enemy", self, " receive ", amount, " of damage")
	hp-= amount
	print("After hit: ", hp)

func selectionStarted():
	canBeSelected = true
	area.monitoring = true
	print("selection started")

func selectionEnded():
	print("Selection ended")
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
#	if(canBeSelected):
#		selectingArrow.visible = false
#	else:
#		return
	selectingArrow.visible = false


