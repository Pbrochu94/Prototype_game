extends CharacterBody2D

@export var speed := 120.0
@export var jump_force := -300.0
@export var gravity := 800.0

@onready var anim = $AnimatedSprite2D


func _physics_process(delta):
	# Gravité
	if not is_on_floor():
		falling(gravity, delta)
		

	
	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	

	# Mouvement gauche/droite
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	# Flip du sprite
	if direction < 0:
		flipAnim("right")
	elif direction > 0:
		flipAnim("left")
	elif direction != 0:
		run()
	else:
		idleAnim()

	move_and_slide()
func idleAnim():
	anim.play("idle")
	print("idle")
func run():
	anim.play("running")
func jump():
	velocity.y = jump_force
	anim.play("jump")
	print("JUMP")
func falling(gravity, delta):
	anim.play("falling")
	velocity.y += gravity * delta
	print("FALLING")	
func flipAnim(direction):
	print("flip")
	if direction == "right":
		anim.flip_h = true
	if direction == "left":
		anim.flip_h = false
