extends Node

@onready var combatMenu = get_tree().get_first_node_in_group("combat menu")
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
	combatMenu.actionSelected.connect(onActionSelected)
	enemy.enemySelected.connect(playerAttack)
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
	player.attack(enemy)

func endPlayerTurn():
	startEnemyTurn()

func startEnemyTurn():
	currentTurn = "enemy"
	enemy.start_turn()

func endEnemyTurn():
	startPlayerTurn()

#BEHAVIORS
func chooseAction():
	currentCombatScene.combatMenu.visible = true
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
	print("ended selection")

func onEnemySelected():
	print(enemy.name)
