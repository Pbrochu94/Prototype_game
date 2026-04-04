extends CharacterBody2D
@export var currentSpeed = 0
@export var jump_force := -300.0
@export var gravity := 800.0
@onready var anim = $SpritePivot/AnimatedSprite2D
const baseSpeed = 60
const pursuitSpeed = 100
var player = null
var justSpawned = true
var direction = 0
var isMoving = false
var playerIsInRange = false
var hasAggro = false
var aggroTimer = 0
var wanderTimer = 0
const wanderDuration = 3
const aggroDuration = 5
enum State {
	IDLE,
	WANDER,
	FALLING,
	PURSUIT
}
@export var currentState = State.WANDER

#Initialize first animation
func _ready():
	direction = 1
	enterState(currentState)
func _physics_process(delta):
	#print(State.keys()[currentState])
	if justSpawned:
		justSpawned = false
		return
	velocity.y += gravity * delta
	
	#Update state
	updateState()
	stateProcess(delta)
	#Update sprite direction
	updateSpriteDirection(direction)
	#Check if enemy still aggro
	updateAggro(delta)
	#Move character/detectwall/modify velocity if hit wall
	move_and_slide()
	#Gère les réactions après les collisions (ex: flip on wall)
	postPhysics()

func postPhysics():
	match currentState:
		State.WANDER:
			if is_on_wall():
				wanderTimer = 0
				direction *= -1


#STATES HANDLERS
func stateProcess(delta):
	match currentState:
		State.IDLE:
			pass
		State.WANDER:
			wander(delta)
		State.PURSUIT:
			pursuit()
func updateState():
	if not is_on_floor():
		pass
	elif not isMoving:
		setState(State.IDLE)
	elif hasAggro:
		setState(State.PURSUIT)
	else:
		setState(State.WANDER)
func setState(newState):
	if currentState == newState:
		return
	exitState(currentState)
	currentState = newState
	enterState(newState)
func enterState(state):
	print(State.keys()[currentState])
	match state:
		State.IDLE:
			updateAnim("idle")
		State.WANDER:
			updateAnim("walk")
		State.FALLING:
			updateAnim("falling")
func exitState(state):
	pass #Not sure yet what happens here


#ANIMATIONS HANDLERS
func updateSpriteDirection(direction):
	if direction < 0:
		$SpritePivot.scale.x = -1
	if direction > 0:
		$SpritePivot.scale.x = 1
func updateAnim(animation):
#	if anim.animation != animation: <---buggy
	anim.play(animation)


#BEHAVIORS
func wander(delta):
	print("WANDER TIMER", wanderTimer)
	print("WANDER DURATION", wanderDuration)
	wanderTimer += delta
	if wanderTimer >= wanderDuration :
		direction *= -1
		wanderTimer = 0
	currentSpeed = baseSpeed
	isMoving = true
	velocity.x = direction * currentSpeed
func pursuit():
	if !hasAggro:
		return
	var dir = sign(player.global_position.x - global_position.x)
	currentSpeed = pursuitSpeed
	direction = dir
	velocity.x = direction * currentSpeed


#DETECTIONS
func updateAggro(delta):
	if hasAggro and not playerIsInRange:
		aggroTimer += delta
		if aggroTimer >= aggroDuration:
			hasAggro = false
			player = null

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		playerIsInRange = true
		hasAggro = true
		setState(State.PURSUIT)


func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		playerIsInRange = false
		setState(State.WANDER)

