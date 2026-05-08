extends Node2D
#NODES
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 
@onready var spriteOrientation:Node2D = $SpritePivot
#@onready var area = $Area2D

#STATS
@export var characterName:String = "Summoner"
@export var walkSpeed:int = 100

#VARIABLES
var currentState:String
var startingPosition:Vector2
var states:Dictionary

#BOOLEANS
var isWalking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.init(self)
	stateMachine.setState(states["intro"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	if global_position == destination:
		isWalking = false
		onFinishedIntro()
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction

func playIntro():
	stateMachine.setState(states["intro"])

func onFinishedIntro():
	stateMachine.setState(states["idle"])
