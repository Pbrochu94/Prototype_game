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
var targets:Array[Node2D]
var target:Node2D
var currentState:String
var startingPosition:Vector2
var states:Dictionary
var allSpell:Dictionary={
	"shield" = preload("res://Summoner/Spells/Shield/Shield.tres"),
	"fire ball" = preload("res://Summoner/Spells/FireBall/FireBall.tres"),
}
var learnedSpells:Dictionary
var spellSelected:SummonerSpell
var faction = Enum.Faction.PLAYER

#BOOLEANS
var isWalking = false

#SIGNALS
signal introAnimCompleted
signal turnFinished

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.init(self)
	setState("intro")
	print(allSpell["shield"])
	for spell in allSpell.values():
		addNewSpell(spell)

#SPRITE & ANIMATIONS
func onAnimationFinished():
	pass
	match anim.animation:
		"casting":
			setState("idle")

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
func castSpell(target:Node2D):
	var spellInstance = spellSelected.spellScene.instantiate()
	print(spellInstance)
	print(target)
	match spellSelected.startingAnimPoint:
		Enum.SummonerSpellStartingPoint.SUMMONER:
			add_child(spellInstance)
		Enum.SummonerSpellStartingPoint.UNIT:
			target.add_child(spellInstance)
	target.applyEffect(spellSelected)
	setState("casting")
	print("Summoner cast ",spellSelected.spellName, " on ", target.characterName)

#TURN FLOW
func playIntro():
	setState("intro")
func onFinishedIntro():
	setState("idle")
	emit_signal("introAnimCompleted")
func endingTurn():
	emit_signal("turnFinished")
	print("Summoner end turn")
	setState("endingturn")
	setState("idle")
#UTILS
func setState(newState:String):
	stateMachine.setState(states[newState])
func addNewSpell(newSpell:SummonerSpell):
	learnedSpells[newSpell.spellName] = newSpell
	print(learnedSpells)
