extends CharacterBody2D

@export var speed := 120.0
@export var jump_force := -300.0
@export var gravity := 800.0
@onready var anim = $AnimatedSprite2D
var direction
enum State {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING
}
var currentState = State.IDLE



func _physics_process(delta):
	#Gravity
	velocity.y += gravity * delta
	print(State.keys()[currentState])

	#Direction
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	#Update state
	updateState(direction)
	#Check for inputs
	inputListener()
	#Update sprite direction
	updateSpriteDirection(direction)
	move_and_slide()

func inputListener():
	if Input.is_action_just_pressed("jump") and currentState in [State.IDLE, State.RUNNING]:
		jump()
func updateState(direction):
	if not is_on_floor():
		if velocity.y < 0:
			setState(State.JUMPING)
		else:
			setState(State.FALLING)
	elif is_on_floor():
		if direction == 0:
			setState(State.IDLE)
		else:
			setState(State.RUNNING)
func setState(newState):
	if currentState == newState:
		return
	exitState(currentState)
	currentState = newState
	enterState(newState)
func enterState(state):
	match state:
		State.IDLE:
			updateAnim("idle")
		State.RUNNING:
			updateAnim("run")
		State.JUMPING:
			updateAnim("jump")
		State.FALLING:
			updateAnim("falling")
func exitState(state):
	pass #Not sure yet what happens here
func updateAnim(animation):
	if anim.animation != animation:
		anim.play(animation)
	print("Switch anim")
func jump():
	velocity.y = jump_force
func updateSpriteDirection(direction):
	if direction < 0:
		anim.flip_h = true
	if direction > 0:
		anim.flip_h = false
