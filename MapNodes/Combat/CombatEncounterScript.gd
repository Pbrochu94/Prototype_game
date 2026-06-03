extends Node2D
class_name CombatEncounter

#NODES
@onready var combatScene = self
@onready var playerAnchor = get_node("PlayerAnchor")
@onready var enemyAnchor = get_node("EnemyAnchor")
@onready var choiceMenu = $ChoiceMenu
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
@onready var targetManager = $TargetManager
@onready var playerPartyManager = $PlayerPartyManager
@onready var enemyPartyManager = $EnemyPartyManager
@onready var summonerAnchor = $SummonerAnchor
@onready var summonerIntroStartingPoint = $SummonerIntroStart
@onready var endingScreen = $RewardScreen
@onready var playerAnchors = [
	$PlayerAnchor1,
	$PlayerAnchor2,
	$PlayerAnchor3,
	$PlayerAnchor4,
	$PlayerAnchor5
]
@onready var enemyAnchors = [
	$EnemyAnchor1,
	$EnemyAnchor2,
	$EnemyAnchor3
]
@onready var environments:Array[PackedScene] = [
	preload("res://MapNodes/Combat/Intro/CaveBackgroundScene.tscn")
]

var playerStartingPosition:Vector2
var enemyStartingPosition:Vector2

#DATA
var combatEncounterData:EncounterData

# Called when the node enters the scene tree for the first time.
func _ready():
	pickRandomBackground()
	initSummoner() 
	combatEncounterData = RunManager.currentEncounterData
	RunManager.summoner.sceneInstance.introAnimCompleted.connect(playerPartyManager.placeUnit)
	enemyPartyManager.init()
	playerPartyManager.init()
#	print_tree()
	endingScreen.init()
	endingScreen.currentCombatScene = combatScene
	turnManager.currentCombatScene = combatScene
	turnManager.init()
	targetManager.init()
	choiceMenu.init()

func initSummoner():
	combatScene.add_child(RunManager.summoner.sceneInstance)
	turnManager.summoner = RunManager.summoner
	RunManager.summoner.sceneInstance.global_position = summonerIntroStartingPoint.global_position
	RunManager.summoner.sceneInstance.startingPosition = summonerAnchor.global_position
	RunManager.summoner.sceneInstance.playIntro()

func pickRandomBackground():
	var randomEnvironment = environments.pick_random()
	var environment = randomEnvironment.instantiate()
	$Background.add_child(environment)
	environment.position = Vector2(0,0)
