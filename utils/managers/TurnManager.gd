extends Node

@onready var choiceMenu = get_tree().get_first_node_in_group("combat menu")
var currentTurn = "player"
var currentCombatScene:Node2D 
var playerPartyManager:Node
var enemyPartyManager:Node
var player:Node2D 
var enemy:Node2D 
var enemyAnchor:Node2D
var isSelecting = false
var playOrder:Array
var currentlyPlaying:Node2D
var playerLost = false
var playerWon = false
var targetManager:Node
signal targetSelectionStarted
signal selectionEnded

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	initVariables()
	initPlayOrder()
	connectSignals()
	playIntro()
	startCombat()

#INIT
func initVariables():
	player = currentCombatScene.player
	playerPartyManager = get_tree().get_first_node_in_group("player party manager")
	enemyPartyManager = get_tree().get_first_node_in_group("enemy party manager")
	targetManager = get_tree().get_first_node_in_group("target manager")
	enemyAnchor = currentCombatScene.enemyAnchor
func connectSignals():
	connectEachInvocations()
	connectEachEnemy()
	choiceMenu.actionSelected.connect(onActionSelected)
	playerPartyManager.partyDead.connect(playerPartyDefeated)
	enemyPartyManager.partyDead.connect(enemyPartyDefeated)	
	targetSelectionStarted.connect(targetManager.startSelection)
	selectionEnded.connect(endSelection)



func connectEachInvocations():
	for invocation in playerPartyManager.party:
		invocation.selectionEnded.connect(endSelection)
		invocation.turnFinished.connect(endTurn)
		invocation.attackChosen.connect(startSelectingTarget)
	print("ORDER",playOrder)
#	playOrder[-1].introFinished.connect(startCombat)

func connectEachEnemy():
	for enemy in enemyPartyManager.party:
		enemy.enemySelected.connect(playerAttack)
		enemy.donePreparing.connect(enemyMoveToAttack)
		enemy.turnFinished.connect(endTurn)

func initPlayOrder():
	for character in get_tree().get_nodes_in_group("unit"):
		playOrder.append(character)
		playOrder.sort_custom(func(a, b):
			return a.speed > b.speed
		)
	currentlyPlaying = playOrder[0]

func updateCurrentlyPlaying():
	if playerLost:
		return
	if not currentlyPlaying:
		currentlyPlaying = playOrder[0]
		return
	var index = playOrder.find(currentlyPlaying)
	index += 1
	if index >= playOrder.size():
		index = 0
	currentlyPlaying = playOrder[index]
	if currentlyPlaying.isDead:
		print("Character :", currentlyPlaying, " is downed")
		updateCurrentlyPlaying()
	else:
		print("Beginning :", currentlyPlaying, "'s turn")

#INTRO---------
func playIntro():
	for invocation in playerPartyManager.party:
		invocation.stateMachine.setState(invocation.stateMachine.states["idle"])
	for enemy in enemyPartyManager.party:
		enemy.stateMachine.setState(enemy.stateMachine.states["idle"])

func startCombat():
	startTurn()
	print("FIGHT START")

#TURN MANAGER
func startTurn():
	if not currentlyPlaying:
		return
	if currentlyPlaying.is_in_group("invocation"):
		chooseAction()
	else:
		currentlyPlaying.startTurn()

func endTurn():
	updateCurrentlyPlaying()
	startTurn()

#PLAYER BEHAVIORS
func chooseAction():
	currentCombatScene.choiceMenu.visible = true
	print("Player is choosing what to do...")

func onActionSelected(action:String):
	print("Player chose:", action)
	match action:
		"attack":
			currentlyPlaying.chooseAttack()
		"inventory":
			pass
		"ability":
			pass

func startSelectingTarget():
	print("Player is selecting a target")
	emit_signal("targetSelectionStarted")
	isSelecting = true

func playerAttack(enemy:Node2D):
	enemy.canBeSelected = false
	print("Player move to attack", enemy)
	#Assign the enemy selected in player node
	currentlyPlaying.target = enemy
	currentlyPlaying.walkToTarget()

func endSelection():
	currentCombatScene.choiceMenu.visible = false
	for enemy in enemyPartyManager.party:
		enemy.selectionEnded()


#ENEMY BEHAVIORS
func enemyMoveToAttack():
	currentlyPlaying.getInPosition()

func enemyAttack():
	enemy.attack()

func playerPartyDefeated():
	currentlyPlaying = null
	playerLost = true
	print("GAME OVER")

func enemyPartyDefeated():
	currentlyPlaying = null
	playerLost = true
	print("You won !!")
