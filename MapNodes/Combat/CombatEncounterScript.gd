extends Node2D
class_name CombatEncounter

#NODES
@onready var combatScene = self
@onready var playerAnchor = get_node("PlayerAnchor")
@onready var enemyAnchor = get_node("EnemyAnchor")
@onready var choiceMenu = $ChoiceMenu
@onready var playerPartyManager = $PlayerPartyManager
@onready var enemyPartyManager = $EnemyPartyManager
@onready var summonerAnchor = $SummonerAnchor
@onready var summonerIntroStartingPoint = $SummonerIntroStart
@onready var playerAnchors = [
	$PlayerAnchor1,
	$PlayerAnchor2,
	$PlayerAnchor3
]
@onready var enemyAnchors = [
	$EnemyAnchor1,
	$EnemyAnchor2,
	$EnemyAnchor3
]
@onready var summoner:Node2D = preload("res://Summoner/SummonerCombatScene.tscn").instantiate()
@onready var environments:Array[PackedScene] = [
	preload("res://MapNodes/Combat/Intro/CaveBackgroundScene.tscn")
]
var player:Node2D 
var enemy:Node2D 
var turnManager:Node
var playerStartingPosition:Vector2
var enemyStartingPosition:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pickRandomBackground()
	turnManager = get_tree().get_first_node_in_group("turn manager")
	turnManager.currentCombatScene = combatScene
	initSummoner()
	enemyPartyManager.init()
	playerPartyManager.init()

func initPlayerPartyData():
	for i in range(playerPartyManager.party.size()):
		var invocation = playerPartyManager.party[i]
		combatScene.add_child(invocation)
		invocation.currentCombatScene = self
		if i < playerAnchors.size():
			invocation.global_position = playerAnchors[i].global_position
			invocation.startingPosition = playerAnchors[i].global_position

#func initEnemyPartyData():
#	for i in range(enemyPartyManager.party.size()):
#		var enemy = enemyPartyManager.party[i]
#		combatScene.add_child(enemy)
#		enemy.currentCombatScene = self
#		if i < enemyAnchors.size():
#			enemy.global_position = enemyAnchors[i].global_position
#			enemy.startingPosition = enemyAnchors[i].global_position

func initSummoner():
	combatScene.add_child(summoner)
	turnManager.summoner = summoner
	summoner.global_position = summonerIntroStartingPoint.global_position
	summoner.startingPosition = summonerAnchor.global_position
	summoner.playIntro()

func pickRandomBackground():
	var randomEnvironment = environments.pick_random()
	var environment = randomEnvironment.instantiate()
	$Background.add_child(environment)
