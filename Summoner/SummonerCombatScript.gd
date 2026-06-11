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
@export var def:SummonerDef 
@export var characterName:String = "Summoner"
#@export var walkSpeed:int = 100

#VARIABLES
var targets:Array[BaseUnitScript]
var target:BaseUnitScript
var currentState:String
var startingPosition:Vector2
var states:Dictionary
var previousState:String
var spellSelected:SummonerSpell
var faction = Enum.Faction.PLAYER
var spellCooldowns:Array
var currentScene

#BOOLEANS
var isWalking = false

#SIGNALS
signal introAnimCompleted
signal turnFinished
signal walkoutFinished

# Called when the node enters the scene tree for the first time.
func _ready():
	stateMachine.init(self)
	def = RunManager.summoner
	setState("intro")
#	for spell in RunManager.allSpells.values():
#		addNewSpell(spell)

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
	global_position = global_position.move_toward(destination, def.walkSpeed*delta)
	if global_position == destination and stateMachine.currentState.name == "Intro":
		isWalking = false
		onFinishedIntro()
	if global_position == destination and stateMachine.currentState.name == "Walkout":
		isWalking = false
		onFinishedWalkout()
func orientSprite(direction:int):
	spriteOrientation.scale.x = direction
func castSpell(target:BaseUnitScript):
	var spellInstance = spellSelected.spellScene.instantiate()
#	spellCooldowns.append({
#		"name": spellSelected.spellName,
#		"cooldown":spellSelected.cooldown,
#	})
	spellSelected.currentCooldown = spellSelected.cooldown
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
func onFinishedWalkout():
	setState("idle")
	emit_signal("walkoutFinished")
func endingTurn():
	emit_signal("turnFinished")
	print("Summoner end turn")
	setState("endingturn")
	setState("idle")
#UTILS
func setState(newState:String):
	stateMachine.setState(states[newState])
#func addNewSpell(newSpell:SummonerSpell):
#	print("learning ", newSpell.spellName)
#	RunManager.learnedSpells[newSpell.spellName] = newSpell
func getInfo():
	var spellCooldowns:Array[Dictionary]
	for spellName in RunManager.learnedSpells:
		if RunManager.learnedSpells[spellName].currentCooldown > 0:
			var spellInfo = {
				"spell": RunManager.learnedSpells[spellName].spellName,
				"spellCooldowns": RunManager.learnedSpells[spellName].currentCooldown 
			}
			spellCooldowns.append(spellInfo)
	return spellCooldowns
func reduceTimers():
	for spellName in RunManager.learnedSpells:
		if RunManager.learnedSpells[spellName].currentCooldown > 0:
			RunManager.learnedSpells[spellName].currentCooldown -= 1
func resetSpellCooldowns():
	for spellName in RunManager.learnedSpells:
		RunManager.learnedSpells[spellName].currentCooldown = 0

func _exit_tree():
	print("SUMMONER EXIT TREE")

