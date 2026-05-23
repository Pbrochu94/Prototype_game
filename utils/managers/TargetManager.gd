extends Node

#NODES
@onready var selectingArrow = $SelectingArrow
@onready var enemyPartyManager = get_tree().get_first_node_in_group("enemy party manager")
@onready var playerPartyManager = get_tree().get_first_node_in_group("player party manager")
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")


#VARIABLES
var enemyParty:Array[Node2D]
var allyParty:Array[Node2D] 
var currentIndex:int = 0
var currentHovered:Node2D = null
var nmbOfTargetToSelect:int
var targets:Array[Node2D]
var nmbOfAvailableTargets:int
var isActive:bool= false

signal selectionEnd



func _ready():
	await get_tree().process_frame
	enemyParty = enemyPartyManager.party
	allyParty = playerPartyManager.party
	selectingArrow.visible = false
	connectSignals()

#ANIMATION & VISUALS
func updateArrow(target):
	if target:
		selectingArrow.global_position = target.global_position + Vector2(0, -50)

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
func enemyHovered(enemy:Node2D):
	currentHovered = enemy
	updateArrow(enemy)
	selectingArrow.visible = true
func enemyUnhovered(enemy:Node2D):
	if currentHovered == enemy:
		currentHovered = null
		selectingArrow.visible = false
func enemySelected(enemy:Node2D):
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
func allyHovered(ally:Node2D):
	currentHovered = ally
	updateArrow(ally)
	selectingArrow.visible = true
func allyUnhovered(ally:Node2D):
	if currentHovered == ally:
		currentHovered = null
		selectingArrow.visible = false
func allySelected(ally:Node2D):
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
			var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters.duplicate()
			nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
			print("Player can select ", nmbOfAvailableTargets, " allie(s)")
			print(allyParty)
			for ally in allyParty:
				ally.canBeSelected = true
				print(ally, ally.canBeSelected)
		Enum.targetPartySelection.ENEMY:
			var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters.duplicate()
			nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
			print("Player can select ", nmbOfAvailableTargets, " enemie(s)")
			for enemy in enemyParty:
				print(enemy)
				enemy.canBeSelected = true
func cancelSelection():
	for enemy in enemyParty:
		enemy.canBeSelected = false
	selectingArrow.visible = false
	targets.clear()
func endSelection():
	for enemy in enemyParty:
		enemy.canBeSelected = false
	for ally in allyParty:
		ally.canBeSelected = false
	selectingArrow.visible = false
	turnManager.unitAttack(targets)
	targets.clear()
	emit_signal("selectionEnd")

#INIT CONNECTIONS
func connectSignals():
	for enemy in enemyParty:
		enemy.hovered.connect(enemyHovered)
		enemy.unhovered.connect(enemyUnhovered)
		enemy.clickedOn.connect(enemySelected)
	for ally in allyParty:
		ally.hovered.connect(allyHovered)
		ally.unhovered.connect(allyUnhovered)
		ally.clickedOn.connect(allySelected)

#NOT WORKING YET
func getCurrentTarget():
	if currentHovered:
		return currentHovered
	return selectNext()
