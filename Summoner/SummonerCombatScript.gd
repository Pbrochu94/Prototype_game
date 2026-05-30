extends Node2D
class_name BaseSummonerScript
#NODES
@onready var anim = $SpritePivot/AnimatedSprite2D
@onready var stateMachine = $StateMachine
@onready var turnManager:Node = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene:Node2D = get_tree().get_first_node_in_group("combat scene") 
@onready var spriteOrientation:Node2D = $SpritePivot
#@onready var area = $Area2D

#STATS
@export var stats:UnitDefinition = preload("res://Summoner/SummonerDefinition.tres")
@export var characterName:String = "Summoner"
@export var walkSpeed:int = 100

#VARIABLES
var targets:Array[BaseUnitScript]
var target:BaseUnitScript
var currentState:String
var startingPosition:Vector2
var states:Dictionary
var previousState:String
var allSpell:Dictionary={
	"shield" = preload("res://Summoner/Spells/Shield/ShieldRes.tres"),
	"fire ball" = preload("res://Summoner/Spells/FireBall/FireBall.tres"),
}
var learnedSpells:Dictionary
var spellSelected:SummonerSpell
var faction = Enum.Faction.PLAYER
var spellCooldowns:Array

#BOOLEANS
var isWalking = false

#SIGNALS
signal introAnimCompleted
signal turnFinished

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.init(self)
	setState("intro")
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
func castSpell(target:BaseUnitScript):
	print(spellSelected.spellName)
	var spellInstance = spellSelected.spellScene.instantiate()
	spellCooldowns.append({
		"name": spellSelected.spellName,
		"cooldown":spellSelected.cooldown,
	})
	match spellSelected.startingAnimPoint:
		Enum.SummonerSpellStartingPoint.SUMMONER:
			add_child(spellInstance)
		Enum.SummonerSpellStartingPoint.UNIT:
			target.add_child(spellInstance)
	var spellResource = spellInstance.spellRes
	if spellSelected.hasEffect:
		target.applyEffect(spellSelected.effectRes)
	setState("casting")
	print("Summoner cast ",spellSelected.spellName, " on ", target.stats.characterName)

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
func getInfo():
	return spellCooldowns
func reduceTimers():
	for i in range(spellCooldowns.size() - 1, -1, -1):
		spellCooldowns[i]["cooldown"] -= 1
		if spellCooldowns[i]["cooldown"] <= 0:
			spellCooldowns.remove_at(i)
