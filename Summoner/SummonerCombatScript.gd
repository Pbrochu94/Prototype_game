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
var allSpell:Dictionary={
	"fire ball" = {
		"path": preload("res://Summoner/Spells/FireBall/FireBall.tres"),
		"cooldown":3,
		"currentCooldown":0
	},
		"shield" = {
		"path": preload("res://Summoner/Spells/Shield/Shield.tres"),
		"cooldown":3,
		"currentCooldown":0
	}
}
var learnedSpells:Dictionary

#BOOLEANS
var isWalking = false

#SIGNALS
signal introAnimCompleted

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.init(self)
	setState("intro")

#BEHAVIOR
func walk(delta, destination:Vector2):
	if not isWalking:
		return
	global_position = global_position.move_toward(destination, walkSpeed*delta)
	if global_position == destination:
		isWalking = false
		onFinishedIntro()
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction
func castSpell(spellIndex:int, target:Node2D):
	var spellInstance = allSpell["shield"]["path"].instanciate()
	target.add_child(spellInstance)
#	print("Summoner cast ",spell.spellName, " on ", target.characterName)

#TURN FLOW
func playIntro():
	setState("intro")
func onFinishedIntro():
	setState("idle")
	emit_signal("introAnimCompleted")

#UTILS
func setState(newState:String):
	stateMachine.setState(states[newState])
func addNewSpell(newSpell:SummonerSpell):
	learnedSpells[newSpell.spellName] = newSpell
