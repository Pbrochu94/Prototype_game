extends Node

#NODES
@onready var choiceMenu = get_tree().get_first_node_in_group("combat menu")
@onready var playerPartyManager:Node = get_tree().get_first_node_in_group("player party manager")
@onready var enemyPartyManager:Node = get_tree().get_first_node_in_group("enemy party manager")
@onready var targetManager:Node = get_tree().get_first_node_in_group("target manager")
var summoner:Node2D 
var currentTurn = "player"
var currentCombatScene:Node2D 
var enemy:Node2D 
var isSelecting = false
var playOrder:Array
var currentlyPlaying:Node2D
var playerLost = false
var playerWon = false

#SIGNALS
signal turnEnded
signal targetSelectionStarted
signal selectionCompleted

func _ready():
	#Wait for all _ready() to complete
	await get_tree().process_frame
	connectSignals()
	playIntro()

#CONNECTIONS
func connectSignals():
	summoner.introAnimCompleted.connect(startCombat)
	connectEachInvocations()
	connectEachEnemy()
	choiceMenu.attackMenu.attackSelected.connect(onAttackSelected)
	choiceMenu.spellMenu.spellSelected.connect(onSpellSelected)
	playerPartyManager.partyDead.connect(playerPartyDefeated)
	enemyPartyManager.partyDead.connect(enemyPartyDefeated)
	targetSelectionStarted.connect(targetManager.startSelection)
	selectionCompleted.connect(endSelection)
	choiceMenu.selectionCancelled.connect(cancelSelection)
	turnEnded.connect(startTurn)
func connectEachInvocations():
	for invocation in playerPartyManager.party:
		invocation.stopSelectingTarget.connect(endSelection)
		invocation.turnFinished.connect(endTurn)
		invocation.startSelectingEnemyTarget.connect(unitSelectingEnemyTarget)
		invocation.selectedSelf.connect(endSelection)
func connectEachEnemy():
	for enemy in enemyPartyManager.party:
		enemy.enemySelected.connect(playerAttack)
		enemy.donePreparing.connect(enemyMoveToAttack)
		enemy.turnFinished.connect(endTurn)

#FIGHT INIT
func playIntro():
	summoner.playIntro()

func startCombat():
	currentCombatScene.initPlayerPartyData()
	currentCombatScene.initEnemyPartyData()
	initPlayOrder()
	startTurn()

#ORDER HANDLERS
func initPlayOrder():
	for character in get_tree().get_nodes_in_group("unit"):
		playOrder.append(character)
		playOrder.sort_custom(func(a, b):
			return a.speed > b.speed
		)
	print("Play order: ",playOrder)
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
		pass

#TURN FLOW
func startTurn():
	if not currentlyPlaying:
		return
	print("Now playing :", currentlyPlaying.getUnitInfo())
	if currentlyPlaying.faction == currentlyPlaying.Faction.SUMMON:
		chooseAction()
	else:
		currentlyPlaying.enemyStartTurn()
func chooseAction():
	currentCombatScene.choiceMenu.open()
	print("Player is choosing what to do...")
func onSpellSelected(spellIndex:int):
	print("ENDDD")
func onAttackSelected(attackIndex:int):
	currentlyPlaying.onChosenAttack(attackIndex)
func unitSelectingEnemyTarget(focusType):
	print("mmh")
	match focusType:
		currentlyPlaying.FocusType.ENEMY, currentlyPlaying.FocusType.AOE:
			print(currentlyPlaying.characterName," is selecting a target")
			emit_signal("targetSelectionStarted")
		currentlyPlaying.FocusType.SELF:
			emit_signal("selectionCompleted")
	isSelecting = true
func unitSelectingAllyTarget():
	pass
func cancelSelection():
	for enemy in enemyPartyManager.party:
		targetManager.selectionEnded()
func endSelection():
	currentCombatScene.choiceMenu.close()
	for enemy in enemyPartyManager.party:
		targetManager.selectionEnded()
func playerAttack(enemy:Node2D):
	enemy.canBeSelected = false
	print("Player move to attack", enemy)
	#Assign the enemy selected in player node
	currentlyPlaying.target = enemy
	currentlyPlaying.getInPosition()
func endTurn():
	updateCurrentlyPlaying()
	emit_signal("turnEnded")

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
