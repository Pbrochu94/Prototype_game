extends Node

#NODES
@onready var selectingArrow = $SelectingArrow
@onready var enemyPartyManager = get_tree().get_first_node_in_group("enemy party manager")
@onready var playerPartyManager = get_tree().get_first_node_in_group("player party manager")
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
@onready var currentCombatScene = get_tree().get_first_node_in_group("combat scene")


#VARIABLES
var enemyParty:Array[UnitInstance]
var allyParty:Array[UnitInstance] 
var currentIndex:int = 0
var currentHovered:UnitInstance = null
var nmbOfTargetToSelect:int
var targets:Array[UnitInstance]
var nmbOfAvailableTargets:int
var currentlyUsedItem:ItemData
var isActive:bool= false
var isSummoning:bool = false
var isUsingItem:bool = false
signal selectionEnd



func init():
#	enemyPartyInstances = currentCombatScene.enemyPartyManager.partyInstances
#	allyPartyInstances = currentCombatScene.playerPartyManager.partyInstances
	selectingArrow.visible = false
	connectSignals()

#ANIMATION & VISUALS
func updateArrow(target:UnitInstance):
	if target:
		selectingArrow.global_position = target.scene.global_position + Vector2(0, -50)

#KEYBOARD HANDLING
func _input(event):
	if event.is_action_pressed("uiDown"):
		var target = selectNext()
		updateArrow(target)
func selectNext():
	var valid = getValidTargets()
	if valid.is_empty():
		return null
	currentIndex = (currentIndex + 1) % valid.size()
	return valid[currentIndex]
func getValidTargets():
	return enemyParty.filter(func(enemy): return not enemy.isDead and enemy.canBeSelected)

#MOUSE HANDLING
func enemyHovered(enemy:UnitInstance):
	if enemy.scene.canBeSelected and isSummoning:
		print("This unit cost : ", enemy.definition.summonCost, " lightshards")
	if enemy.scene.canBeSelected and not isSummoning:
		print(enemy.getUnitInfo())
	currentHovered = enemy
	updateArrow(enemy)
	selectingArrow.visible = true
func enemyUnhovered(enemy:UnitInstance):
	if currentHovered == enemy:
		currentHovered = null
		selectingArrow.visible = false
func enemySelected(enemy:UnitInstance):
	if enemy not in targets and not enemy.isDead:
		targets.append(enemy)
		nmbOfAvailableTargets -= 1
		print("selected ",enemy)
		print("Player can select ", nmbOfAvailableTargets, " targets")
	elif enemy in targets:
		print("enemy already selected or dead")
	if nmbOfAvailableTargets <= 0:
		endSelection()
#MOUSE HANDLING
func allyHovered(ally:UnitInstance):
	currentHovered = ally
	updateArrow(ally)
	selectingArrow.visible = true
func allyUnhovered(ally:UnitInstance):
	if currentHovered == ally:
		currentHovered = null
		selectingArrow.visible = false
func allySelected(ally:UnitInstance):
	if ally not in targets and not ally.isDead:
		targets.append(ally)
		nmbOfAvailableTargets -= 1
		print("selected ",ally)
		print("Player can select ", nmbOfAvailableTargets, " targets")
	elif ally in targets:
		print("enemy already selected or dead")
	if nmbOfAvailableTargets <= 0:
		endSelection()


#SELECTION FLOW
func startSelection(nmbOfTarget:int, partyFocus:Enum.targetPartySelection):
	nmbOfTargetToSelect = nmbOfTarget
	match partyFocus:
		Enum.targetPartySelection.ALLY:
			var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters
			nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
			print("Player can select ", nmbOfAvailableTargets, " allie(s)")
			for ally in allyParty:
				ally.scene.canBeSelected = true
		Enum.targetPartySelection.ENEMY:
			var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters
			nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
			print("Player can select ", nmbOfAvailableTargets, " enemie(s)")
			for enemy in enemyPartyManager.party:
				if not enemy.isDead:
					enemy.scene.canBeSelected = true
func startItemSelection(item:ItemData):
	turnManager.currentlyUsedItem = item
	isUsingItem = true
	nmbOfTargetToSelect = item.nmbOfTargets
	match item.partyAffected:
		Enum.targetPartySelection.ALLY:
			var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters
			nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
			print("Player can select ", nmbOfAvailableTargets, " allie(s)")
			for ally in allyParty:
				ally.scene.canBeSelected = true
		Enum.targetPartySelection.ENEMY:
			var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters
			nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
			print("Player can select ", nmbOfAvailableTargets, " enemie(s)")
			for enemy in enemyParty:
				if not enemy.isDead:
					enemy.scene.canBeSelected = true
func invocationSelectionStarted():
	isSummoning = true
	for enemy in enemyParty:
		enemy.scene.canBeSelected = true
		enemy.scene.isSelectingToSummon = true
func invocationSelectionEnded():
	isSummoning = false
	for enemy in enemyParty:
		enemy.canBeSelected = false
func cancelSelection():
	for enemy in enemyParty:
		enemy.scene.canBeSelected = false
	for ally in allyParty:
		ally.scene.canBeSelected = false
	selectingArrow.visible = false
	targets.clear()
func endSelection():
	for enemy in enemyParty:
		enemy.scene.canBeSelected = false
	for ally in allyParty:
		ally.scene.canBeSelected = false
	selectingArrow.visible = false
	if isUsingItem:
		turnManager.useItem(targets)
	else:
		turnManager.unitAttack(targets)
	targets.clear()
	emit_signal("selectionEnd")

#INIT CONNECTIONS
func connectSignals():
	for enemy in enemyPartyManager.party:
		enemy.scene.hovered.connect(enemyHovered)
		enemy.scene.unhovered.connect(enemyUnhovered)
		enemy.scene.clickedOn.connect(enemySelected)
	for ally in playerPartyManager.party:
		ally.scene.hovered.connect(allyHovered)
		ally.scene.unhovered.connect(allyUnhovered)
		ally.scene.clickedOn.connect(allySelected)

#NOT WORKING YET
func getCurrentTarget():
	if currentHovered:
		return currentHovered
	return selectNext()
