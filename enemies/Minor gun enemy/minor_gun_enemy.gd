extends CharacterBody2D
@export var currentSpeed = 0
@export var jump_force := -300.0
@export var gravity := 800.0
@onready var anim = $SpritePivot/AnimatedSprite2D
const baseSpeed = 60
var justSpawned = true
var direction = 0
var isMoving = false
var playerIsInRange = false
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
	if justSpawned:
		justSpawned = false
		return
	velocity.y += gravity * delta
	
	#Update state
	updateState()
	stateProcess()
	#Update sprite direction
	updateSpriteDirection(direction)
	#Move character/detectwall/modify velocity if hit wall
	move_and_slide()
	#Gère les réactions après les collisions (ex: flip on wall)
	postPhysics()
func postPhysics():
	match currentState:
		State.WANDER:
			if is_on_wall():
				direction *= -1


#STATES HANDLERS
func stateProcess():
	match currentState:
		State.IDLE:
			pass
		State.WANDER:
			#direction = 1
			wander()
		State.PURSUIT:
			pursuit()
func updateState():
	if not is_on_floor():
		pass
	elif not isMoving:
		setState(State.IDLE)
	elif playerIsInRange:
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
			wander()
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
func wander():
	currentSpeed = baseSpeed
	#print("step")
	isMoving = true
	velocity.x = direction * currentSpeed
func pursuit():
	currentSpeed = 120
	velocity.x = direction * currentSpeed
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		playerIsInRange = true
		print("DETECTED")
		setState(State.PURSUIT)


func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		playerIsInRange = false
		print("RESET AGGRO")
		setState(State.WANDER)
