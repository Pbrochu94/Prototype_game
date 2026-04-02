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
	#Update animation
	updateAnim()
	move_and_slide()

func inputListener():
	if Input.is_action_just_pressed("jump") and currentState in [State.IDLE, State.RUNNING]:
		jump()
	
func updateState(direction):
	if not is_on_floor():
		if velocity.y < 0:
			currentState = State.JUMPING
		else:
			currentState = State.FALLING
	elif is_on_floor():
		if direction == 0:
			currentState = State.IDLE
		else:
			currentState = State.RUNNING
func updateAnim():
	match currentState:
		State.IDLE:
			if anim.animation != "idle":
				anim.play("idle")
		State.RUNNING:
			if anim.animation != "running":
				anim.play("running")
		State.JUMPING:
			if anim.animation != "jump":
				anim.play("jump")
		State.FALLING:
			if anim.animation != "falling":
				anim.play("falling")
func jump():
	velocity.y = jump_force
	print("JUMP")
func updateSpriteDirection(direction):
	if direction < 0:
		anim.flip_h = true
	if direction > 0:
		anim.flip_h = false
