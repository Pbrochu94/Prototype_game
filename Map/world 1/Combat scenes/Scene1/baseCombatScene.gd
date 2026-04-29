extends Node2D

@onready var combatScene = self
@onready var playerAnchor = get_node("PlayerAnchor")
@onready var enemyAnchor = get_node("EnemyAnchor")
@onready var choiceMenu = $ChoiceMenu
@onready var playerPartyManager = $PartyManager
@onready var enemyPartyManager = $EnemyPartyManager
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
var player:Node2D 
var enemy:Node2D 
var turnManager:Node
var playerStartingPosition:Vector2
var enemyStartingPosition:Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	turnManager = get_tree().get_first_node_in_group("turn manager")
	initPlayerPartyData()
	initEnemyPartyData()
#	playerStartingPosition = playerAnchor.global_position
#	enemyStartingPosition = enemyAnchor.global_position
#	player.currentCombatScene = combatScene
	turnManager.currentCombatScene = combatScene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initPlayerPartyData():
	for i in range(playerPartyManager.party.size()):
		var invocation = playerPartyManager.party[i]
		invocation.currentCombatScene = self
		if i < playerAnchors.size():
			invocation.startingPosition = playerAnchors[i].global_position

func initEnemyPartyData():
	for i in range(enemyPartyManager.party.size()):
		var invocation = enemyPartyManager.party[i]
		invocation.currentCombatScene = self
		if i < playerAnchors.size():
			invocation.startingPosition = enemyAnchors[i].global_position
