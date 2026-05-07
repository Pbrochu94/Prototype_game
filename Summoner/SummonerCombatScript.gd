extends Node2D
#NODES
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var startingPosition:Vector2
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 
@onready var spriteOrientation:Node2D = $SpritePivot
#@onready var area = $Area2D

#STATS
var characterName:String = "Summoner"

#VARIABLES
var currentState:String

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.init(self)
	stateMachine.setState(stateMachine.states["idle"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func orientSprite(direction:int):
	spriteOrientation.scale.x = direction
