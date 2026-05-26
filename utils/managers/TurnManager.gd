extends Node

#NODES
@onready var choiceMenu = get_tree().get_first_node_in_group("combat menu")
@onready var playerPartyManager:Node = get_tree().get_first_node_in_group("player party manager")
@onready var enemyPartyManager:Node = get_tree().get_first_node_in_group("enemy party manager")
@onready var targetManager:Node = get_tree().get_first_node_in_group("target manager")
@onready var everyUnits:Array[Node] 
@onready var currentCombatScene = $CombatEncounterScene
var everyLivingUnits
var summoner:Node2D 
var currentTurn = "player"
var enemy:Node2D 
var isSelecting = false
var playOrder:Array
var currentlyPlaying:Node2D
var playerLost:bool = false
var playerWon:bool = false
var turnTracker:int = 0
var fightIsOver:bool = false
var caster:Enum.Caster


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
	currentCombatScene.summoner.introAnimCompleted.connect(startCombat)
	currentCombatScene.summoner.turnFinished.connect(endTurn)
	connectEachInvocations()
	connectEachEnemy()
	choiceMenu.attackMenu.attackSelected.connect(onAttackSelected)
	choiceMenu.spellMenu.spellSelected.connect(onSpellSelected)
	turnEnded.connect(startTurn)
func connectEachInvocations():
	for invocation in playerPartyManager.party:
		invocation.stopSelectingTarget.connect(endSelection)
		invocation.turnFinished.connect(endTurn)
		invocation.startSelectingEnemyTarget.connect(unitSelectingTarget)
		invocation.selectedSelf.connect(endSelection)
func connectEachEnemy():
	for enemy in enemyPartyManager.party:
#		enemy.enemySelected.connect(playerAttack)
		enemy.donePreparing.connect(enemyMoveToAttack)
		enemy.turnFinished.connect(endTurn)

#FIGHT INIT
func playIntro():
	currentCombatScene.summoner.playIntro()

func startCombat():
	initPlayOrder()
	startTurn()

#ORDER HANDLERS
func initPlayOrder():
	everyUnits = get_tree().get_nodes_in_group("unit")
	for unit in everyUnits:
		playOrder.append(unit)
	updatePlayOrder()
	currentlyPlaying = playOrder[0]
func updatePlayOrder():
	for unit in playOrder:
		if unit.isDead:
			playOrder.erase(unit)
	playOrder.sort_custom(func(a, b):
		if a.stats.speed == b.stats.speed:
			return a.faction == Enum.Faction.ENEMY
		return a.stats.speed > b.stats.speed
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
		updateCurrentlyPlaying()
	else:
		pass
func resetPlayingOrder():
	currentlyPlaying = playOrder[0]
#TURN FLOW
func startTurn():
	if not currentlyPlaying:
		return
	currentlyPlaying.reduceTimers()
	print("Now playing :", currentlyPlaying.getUnitInfo())
	print("Summoner info: " ,summoner.getInfo())
	if currentlyPlaying.faction == Enum.Faction.PLAYER:
		chooseAction()
	else:
		currentlyPlaying.enemyStartTurn()
func chooseAction():
	currentCombatScene.choiceMenu.open()
	print(currentlyPlaying.stats.characterName," is choosing what to do...")
func onSpellSelected(spellIndex:int):
	caster = Enum.Caster.SUMMONER
	summoner.spellSelected = summoner.learnedSpells.values()[spellIndex]
	unitSelectingTarget(summoner.spellSelected.focusType,summoner.spellSelected.numberOfTargets)
func onAttackSelected(attackIndex:int):
	caster = Enum.Caster.UNIT
	currentlyPlaying.onChosenAttack(attackIndex)
func unitSelectingTarget(focusType, nmbOfTargets):
	match focusType:
		Enum.FocusType.ENEMY_SINGLE, Enum.FocusType.ENEMY_AOE:
			print(currentlyPlaying.stats.characterName," is selecting a target")
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
func unitAttack(targets:Array[Node2D]):
		summoner.targets = targets
		match caster:
			Enum.Caster.SUMMONER:
				for target in targets:
					summoner.target = target
					target.canBeSelected = false
					summoner.castSpell(summoner.target)
			Enum.Caster.UNIT:
				for target in targets:
					currentlyPlaying.target = target
					target.canBeSelected = false
					if currentlyPlaying.attackSelected.needToMove:
						currentlyPlaying.getInPosition(target)
					else:
						currentlyPlaying.attack(target, currentlyPlaying.attackSelected)
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
	summoner.reduceTimers()
	updatePlayOrder()
	resetPlayingOrder()
	emit_signal("turnEnded")
func endFight():
	emit_signal("playOutroAnim")
	for unit in playerPartyManager.party:
		unit.resetAllStatsBesideHp()
	if playerWon:
		print("You won !!")
		openEndingScreen()
	else:
		print("GAME OVER")
		RunManager.nodes[RunManager.currentNode]["completed"] = false
		get_tree().change_scene_to_file("res://MapNodes/OverworldMap/OverworldMap.tscn")
func openEndingScreen():
	currentCombatScene.endingScreen.open()

#ENEMY BEHAVIORS
func enemyMoveToAttack(target:Node2D):
	currentlyPlaying.getInPosition(target)
func enemyAttack():
	enemy.attack()

