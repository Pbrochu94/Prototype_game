extends Node2D

@export var hp = 100
@export var attackPower = 10
@export var weponEquipped = "sword"
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var actionsUI = $PlayerActionsUI

var currentState
var direction
enum State {
	IDLE,
	ATTACK,
	DAMAGE,
	DEAD
}
# Called when the node enters the scene tree for the first time.
func _ready():
	currentState = State.IDLE
	print("UI:", actionsUI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateAnimation()

#STATES HANDLERS
func setState():
	pass

func enterState():
	print(currentState)

func exitState():
	pass


#ANIMATIONS HANDLERS
func updateAnimation():
	match currentState:
		State.IDLE:
			anim.play("idle")
		State.ATTACK:
			anim.play("attack")

#BEHAVIORS
func startTurn():
	print("Player start")
	actionsUI.visible = true


func attack(weapon):
	pass
