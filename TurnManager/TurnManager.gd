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
	enemyAnchor = currentCombatScene.enemyAnchor
	player = currentCombatScene.player
	enemy = currentCombatScene.enemy
	player.introFinished.connect(startCombat)
	choiceMenu.actionSelected.connect(onActionSelected)
	enemy.enemySelected.connect(playerAttack)
	selectionEnded.connect(endSelection)
	player.selectionEnded.connect(endSelection)
	playIntro()

#INTRO---------
func playIntro():
	if player and enemy:
		player.playIntroWalk(currentCombatScene.playerStartingPosition)
		enemy.playIntroWalk(currentCombatScene.enemyStartingPosition)
	else:
		print("ERROR: COMBAT SCENE COULD NOT GET PLAYER ENEMY OR TURN MANAGER")

func startCombat():
	startPlayerTurn()

#TURN MANAGER
func startPlayerTurn():
	currentTurn = "player"
	chooseAction()

func playerAttack(enemy:Node2D):
	print("Player move to attack", enemy)
	#Assign the enemy selected in player node
	player.enemyTargeted = enemy
	player.walkToTarget ()

func endPlayerTurn():
	startEnemyTurn()

func startEnemyTurn():
	currentTurn = "enemy"
	enemy.start_turn()

func endEnemyTurn():
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
	print("ended selection")

func onEnemySelected():
	print(enemy.name)
