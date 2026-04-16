extends Node

@onready var choiceMenu = get_tree().get_first_node_in_group("combat menu")
var currentTurn = "player"
var currentCombatScene:Node2D 
var player:Node2D 
var enemy:Node2D 
var enemyAnchor:Node2D
var isSelecting = false
signal selectionStarted
signal selectionEnded

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	choiceMenu.actionSelected.connect(onActionSelected)
	enemyAnchor = currentCombatScene.enemyAnchor
	player = currentCombatScene.player
	player.startingPosition =  currentCombatScene.playerStartingPosition
	player.introFinished.connect(startCombat)
	player.selectionEnded.connect(endSelection)
	player.turnFinished.connect(endPlayerTurn)
#	enemy = currentCombatScene.enemy
#	enemy.enemySelected.connect(playerAttack)
#	enemy.donePreparing.connect(enemyMoveToAttack)
#	enemy.inPositionToAttack.connect(enemyAttack)
#	enemy.turnFinished.connect(endEnemyTurn)
	selectionEnded.connect(endSelection)
	playIntro()

#INTRO---------
func playIntro():
#	if player and enemy:
	player.playIntroWalk(currentCombatScene.playerStartingPosition)
#		enemy.playIntroWalk(currentCombatScene.enemyStartingPosition)
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
	player.enemyTargeted = enemy
	player.walkToTarget ()

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
			startSelection()
		"inventory":
			pass
		"ability":
			pass

func startSelection():
	print("Player is selecting a target")
	emit_signal("selectionStarted")
	isSelecting = true

func endSelection():
	currentCombatScene.choiceMenu.visible = false
	enemy.selectionEnded()

func onEnemySelected():
	print(enemy.name)
