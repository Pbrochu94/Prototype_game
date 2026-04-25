extends Node

@onready var choiceMenu = get_tree().get_first_node_in_group("combat menu")
var currentTurn = "player"
var currentCombatScene:Node2D 
var playerPartyManager:Node
var player:Node2D 
var enemy:Node2D 
var enemyAnchor:Node2D
var isSelecting = false
var playOrder:Array
var currentlyPlaying:Node2D
signal targetSelectionStarted
signal selectionEnded

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	initPlayOrder()
	initVariables()
	connectSignals()
	playIntro()

#INTRO---------
func playIntro():
#	if player and enemy:
	player.playIntroWalk(currentCombatScene.playerStartingPosition)
	enemy.playIntroWalk(currentCombatScene.enemyStartingPosition)
#	else:
#		print("ERROR: COMBAT SCENE COULD NOT GET PLAYER ENEMY OR TURN MANAGER")

func startCombat():
	startPlayerTurn()

#TURN MANAGER
func startPlayerTurn():
	chooseAction()

func playerAttack(enemy:Node2D):
	enemy.canBeSelected = false
	print("Player move to attack", enemy)
	#Assign the enemy selected in player node
	player.target = enemy
	player.walkToTarget()

func endPlayerTurn():
	startEnemyTurn()

func startEnemyTurn():
#	currentTurn = "enemy"
	enemy.startTurn()

func enemyMoveToAttack():
	enemy.getInPosition()

func enemyAttack():
	enemy.attack()

func endEnemyTurn():
	print("Enemy turn is oveer")
	startPlayerTurn()

#BEHAVIORS
func chooseAction():
	currentCombatScene.choiceMenu.visible = true
	print("Player is choosing what to do...")

func onActionSelected(action:String):
	print("Player chose:", action)
	match action:
		"attack":
			player.chooseAttack()
		"inventory":
			pass
		"ability":
			pass

func startSelectingTarget():
	print("Player is selecting a target")
	emit_signal("targetSelectionStarted")
	isSelecting = true

func endSelection():
	currentCombatScene.choiceMenu.visible = false
	enemy.selectionEnded()

func connectSignals():
	choiceMenu.actionSelected.connect(onActionSelected)
	player.introFinished.connect(startCombat)
	player.selectionEnded.connect(endSelection)
	player.turnFinished.connect(endPlayerTurn)
	player.attackChosen.connect(startSelectingTarget)
	enemy = currentCombatScene.enemy
	enemy.startingPosition = currentCombatScene.enemyStartingPosition
	enemy.enemySelected.connect(playerAttack)
	enemy.donePreparing.connect(enemyMoveToAttack)
	enemy.turnFinished.connect(endEnemyTurn)
	playerPartyManager.partyDead.connect(playerDefeated)
	selectionEnded.connect(endSelection)

func initVariables():
	player = currentCombatScene.player
	player.startingPosition =  currentCombatScene.playerStartingPosition
	playerPartyManager = get_tree().get_first_node_in_group("player party manager")
	enemyAnchor = currentCombatScene.enemyAnchor

func initPlayOrder():
	for character in get_tree().get_nodes_in_group("character"):
		playOrder.append(character)
		playOrder.sort_custom(func(a, b):
			return a.speed > b.speed
		)
	print("ORDERRRRR", playOrder)

func onEnemySelected():
	print(enemy.name)

func playerDefeated():
	print("Game over")
