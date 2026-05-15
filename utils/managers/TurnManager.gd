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
var playerLost:bool = false
var playerWon:bool = false
var turnTracker:int = 0
var fightIsOver:bool = false

#SIGNALS
signal turnEnded
signal targetSelectionStarted(nmbOfTarget:int)
signal selectionCompleted
signal playOutroAnim

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
	turnEnded.connect(startTurn)
func connectEachInvocations():
	for invocation in playerPartyManager.party:
		invocation.stopSelectingTarget.connect(endSelection)
		invocation.turnFinished.connect(endTurn)
		invocation.startSelectingEnemyTarget.connect(unitSelectingEnemyTarget)
		invocation.selectedSelf.connect(endSelection)
func connectEachEnemy():
	for enemy in enemyPartyManager.party:
#		enemy.enemySelected.connect(playerAttack)
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
	updatePlayOrder()
	currentlyPlaying = playOrder[0]
func updatePlayOrder():
	playOrder.sort_custom(func(a, b):
		return a.speed > b.speed
	)
	print("Updating play order : ", playOrder)
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
		print("Character :", currentlyPlaying.characterName, " is downed")
		updateCurrentlyPlaying()
	else:
		pass

#TURN FLOW
func startTurn():
	if not currentlyPlaying:
		return
	print("Now playing :", currentlyPlaying.getUnitInfo())
	currentlyPlaying.reduceTimers()
	if currentlyPlaying.faction == Enum.Faction.PLAYER:
		chooseAction()
	else:
		currentlyPlaying.enemyStartTurn()
func chooseAction():
	currentCombatScene.choiceMenu.open()
	print("Player is choosing what to do...")
func onSpellSelected(spellIndex:int):
	print("ENDDD")
	var spellName = summoner.spells[spellIndex]
	var spellSelected = summoner.spells[spellName]
	unitSelectingEnemyTarget(spellSelected.focusType,spellSelected.nmbOfTargets)
	summoner.castSpell(spellIndex)
func onAttackSelected(attackIndex:int):
	currentlyPlaying.onChosenAttack(attackIndex)
func unitSelectingEnemyTarget(focusType, nmbOfTargets):
	match focusType:
		Enum.FocusType.ENEMY_SINGLE, Enum.FocusType.ENEMY_AOE:
			print(currentlyPlaying.characterName," is selecting a target")
			targetManager.startSelection(nmbOfTargets)
		Enum.FocusType.SELF:
			emit_signal("selectionCompleted")
		Enum.FocusType.ENEMY_MULTIPLE:
			targetManager.startSelection(nmbOfTargets)
	isSelecting = true
func unitSelectingAllyTarget():
	pass
func endSelection():
	currentCombatScene.choiceMenu.close()
	for enemy in enemyPartyManager.party:
		targetManager.endSelection()
func playerAttack(enemies:Array[Node2D]):
	for enemy in enemies:
		currentlyPlaying.target = enemy
		enemy.canBeSelected = false
		print(currentlyPlaying.characterName," move to attack", enemy.characterName)
		currentlyPlaying.attack(enemy, currentlyPlaying.attackSelected)
		#Assign the enemy selected in player node
#		currentlyPlaying.target = enemy
		if currentlyPlaying.attackSelected.focusType == Enum.FocusType.ENEMY_AOE:
			for teamate in currentlyPlaying.party:
				currentlyPlaying.collateralTargets.append(teamate)
#		currentlyPlaying.getInPosition()
func endTurn():
	if fightIsOver:
		endFight()
	else:
		currentlyPlaying == playOrder[-1]
		turnTracker += 1
		print("turn ", turnTracker, " completed")
		updatePlayOrder()
		updateCurrentlyPlaying()
		emit_signal("turnEnded")
func endFight():
	emit_signal("playOutroAnim")
	if playerWon:
		print("You won !!")
	else:
		print(playerWon)
		print("GAME OVER")

#ENEMY BEHAVIORS
func enemyMoveToAttack():
	currentlyPlaying.getInPosition()
func enemyAttack():
	enemy.attack()

#PARTY BEHAVIORS
func playerPartyDefeated():
	currentlyPlaying = null
	playerLost = true
#	emit_signal("playOutroAnim")
	print("GAME OVER")
func enemyPartyDefeated():
	currentlyPlaying = null
	playerLost = true
#	emit_signal("playOutroAnim")
	print("You won !!")
