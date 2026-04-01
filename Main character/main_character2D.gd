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
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false


		
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")

	move_and_slide()

func jump():
	velocity.y = jump_force
	anim.play("jump")
	print("JUMP")
func falling(gravity, delta):
	anim.play("falling")
	velocity.y += gravity * delta
	print("FALLING")	
