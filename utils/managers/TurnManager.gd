extends Node

#NODES
@onready var choiceMenu = get_tree().get_first_node_in_group("combat menu")
@onready var playerPartyManager:Node = get_tree().get_first_node_in_group("player party manager")
@onready var enemyPartyManager:Node = get_tree().get_first_node_in_group("enemy party manager")
@onready var targetManager:Node = get_tree().get_first_node_in_group("target manager")
@onready var everyUnits:Array[UnitInstance] 
@onready var currentCombatScene = $CombatEncounterScene
var everyLivingUnits
var summoner:SummonerDef
var currentTurn = "player"
var enemy:UnitInstance 
var isSelecting = false
var playOrder:Array[UnitInstance]
var currentlyPlaying:UnitInstance
var playerLost:bool = false
var playerWon:bool = false
var turnTracker:int = 0
var fightIsOver:bool = false
var caster:Enum.Caster
var currentlyUsedItem:ItemData


#SIGNALS
signal turnEnded
signal targetSelectionStarted(nmbOfTarget:int)
signal selectionCompleted
signal playOutroAnim

func init():
	connectSignals()
	playIntro()

#CONNECTIONS
func connectSignals():
	RunManager.summoner.sceneInstance.introAnimCompleted.connect(startCombat)
	RunManager.summoner.sceneInstance.turnFinished.connect(endTurn)
	connectEachInvocations()
	connectEachEnemy()
	choiceMenu.attackMenu.attackSelected.connect(onAttackSelected)
	choiceMenu.spellMenu.spellSelected.connect(onSpellSelected)
	turnEnded.connect(startTurn)
func connectEachInvocations():
	for invocation in playerPartyManager.partyInstances:
		invocation.stopSelectingTarget.connect(endSelection)
		invocation.turnFinished.connect(endTurn)
		invocation.startSelectingEnemyTarget.connect(unitSelectingTarget)
		invocation.selectedSelf.connect(endSelection)
func connectEachEnemy():
	for enemyInstance in enemyPartyManager.partyInstances:
#		enemy.enemySelected.connect(playerAttack)
		enemyInstance.donePreparing.connect(enemyMoveToAttack)
		enemyInstance.turnFinished.connect(endTurn)

#FIGHT INIT
func playIntro():
	RunManager.summoner.sceneInstance.playIntro()

func startCombat():
	currentCombatScene.startCombat()
	initPlayOrder()
	startTurn()

#ORDER HANDLERS
func initPlayOrder():
	for unit in playerPartyManager.party:
		everyUnits.append(unit)
	for unit in enemyPartyManager.party:
		everyUnits.append(unit)
	for unit in everyUnits:
		playOrder.append(unit)
	updatePlayOrder()
	currentlyPlaying = playOrder[0]
func updatePlayOrder():
	for unit in playOrder:
		if unit.isDead:
			playOrder.erase(unit)
	playOrder.sort_custom(func(a, b):
		if a.speed == b.speed:
			return a.faction == Enum.Faction.ENEMY
		return a.speed > b.speed
	)
#	print("Updating play order : ", playOrder)
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
		updateCurrentlyPlaying()
	else:
		pass
func resetPlayingOrder():
	currentlyPlaying = playOrder[0]
#TURN FLOW
func startTurn():
	if not currentlyPlaying:
		return
	currentlyPlaying.scene.reduceTimers()
	print("Now playing :", currentlyPlaying.getUnitInfo())
	print("Summoner info: " ,summoner.sceneInstance.getInfo())
	if currentlyPlaying.faction == Enum.Faction.PLAYER:
		chooseAction()
	else:
		currentlyPlaying.scene.enemyStartTurn()
func chooseAction():
	currentCombatScene.choiceMenu.open()
	print(currentlyPlaying.characterName," is choosing what to do...")
func onSpellSelected(spell:SummonerSpell):
	caster = Enum.Caster.SUMMONER
	summoner.sceneInstance.spellSelected = spell
	unitSelectingTarget(spell.focusType,spell.numberOfTargets)
func onAttackSelected(attack:Ability):
	caster = Enum.Caster.UNIT
	currentlyPlaying.scene.onChosenAttack(attack)
func unitSelectingTarget(focusType, nmbOfTargets):
	match focusType:
		Enum.FocusType.ENEMY_SINGLE, Enum.FocusType.ENEMY_AOE:
			print(currentlyPlaying.characterName," is selecting a target")
			targetManager.startSelection(nmbOfTargets, Enum.targetPartySelection.ENEMY)
		Enum.FocusType.SELF:
			emit_signal("selectionCompleted")
		Enum.FocusType.ENEMY_MULTIPLE:
			targetManager.startSelection(nmbOfTargets, Enum.targetPartySelection.ENEMY)
		Enum.FocusType.ALLY_SINGLE:
			targetManager.startSelection(nmbOfTargets, Enum.targetPartySelection.ALLY)
	isSelecting = true
func unitSelectingAllyTarget():
	pass
func endSelection():
	currentCombatScene.choiceMenu.close()
	for enemy in enemyPartyManager.party:
		targetManager.endSelection()
func unitAttack(targets:Array[UnitInstance]):
		choiceMenu.attackMenu.resetAttackButton()
		summoner.sceneInstance.targets = targets
		match caster:
			Enum.Caster.SUMMONER:
				for target in targets:
					summoner.sceneInstance.target = target
					target.scene.canBeSelected = false
					summoner.sceneInstance.castSpell(summoner.sceneInstance.target)
			Enum.Caster.UNIT:
				for target in targets:
					currentlyPlaying.scene.target = target
					target.scene.canBeSelected = false
					if currentlyPlaying.scene.attackSelected.needToMove:
						currentlyPlaying.scene.getInPosition(target)
					else:
						currentlyPlaying.scene.attack(target, currentlyPlaying.scene.attackSelected)
func useItem(targets:Array[UnitInstance]):
	for target in targets:
		currentlyUsedItem.use(target)
	RunManager.inventory[currentlyUsedItem.itemName].stack -= 1
	print("Inventory: ", RunManager.inventory[currentlyUsedItem.itemName].stack)
	currentlyUsedItem = null
	targetManager.isUsingItem = false
	endTurn()
func endTurn():
	if fightIsOver:
		endFight()
	else:
		if currentlyPlaying == playOrder[-1]:
			endGlobalTurn()
		else:
			updateCurrentlyPlaying()
			emit_signal("turnEnded")
func endGlobalTurn():
	turnTracker += 1
	print("turn ", turnTracker, " completed")
	summoner.sceneInstance.reduceTimers()
	updatePlayOrder()
	resetPlayingOrder()
	emit_signal("turnEnded")
func endFight():
	emit_signal("playOutroAnim")
	for unit in playerPartyManager.currentlyAliveCharacters:
		unit.scene.resetAllStatsBesideHp()
	summoner.sceneInstance.resetSpellCooldowns()
	if playerWon:
		print("You won !!")
		openEndingScreen()
	else:
		print("GAME OVER")
#		RunManager.nodes[RunManager.currentNodeId]["completed"] = false
		RunManager.gameOver()
func openEndingScreen():
	currentCombatScene.endingScreen.open()

#ENEMY BEHAVIORS
func enemyMoveToAttack(target:UnitInstance):
	currentlyPlaying.getInPosition(target)
func enemyAttack():
	pass
#	enemy.attack()

