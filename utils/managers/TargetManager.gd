extends Node

#NODES
@onready var selectingArrow = $SelectingArrow
@onready var enemyPartyManager = get_tree().get_first_node_in_group("enemy party manager")
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")


#VARIABLES
var enemies:Array[Node2D] = []
var currentIndex:int = 0
var currentHovered:Node2D = null
var nmbOfTargetToSelect:int
var targets:Array[Node2D]
var nmbOfAvailableTargets:int


func _ready():
	enemies = enemyPartyManager.party
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
	return enemies.filter(func(enemy): return not enemy.isDead and enemy.canBeSelected)

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
		if targets.size() == nmbOfTargetToSelect:
			turnManager.playerAttack(enemy)
			targets.clear()
	elif enemy in targets:
		print("enemy already selected or dead")


#SELECTION FLOW
func startSelection(nmbOftarget):
	var unitSelectable = turnManager.enemyPartyManager.currentlyAliveCharacters
	nmbOfTargetToSelect = nmbOftarget
	nmbOfAvailableTargets = min(nmbOfTargetToSelect, unitSelectable.size())
	print("Player can select ", nmbOfAvailableTargets, " targets")
	for enemy in enemies:
		enemy.canBeSelected = true
		print(enemy, enemy.canBeSelected)
func selectionEnded():
	for enemy in enemies:
		enemy.canBeSelected = false
	selectingArrow.visible = false

#INIT CONNECTIONS
func connectSignals():
	for enemy in enemies:
		enemy.hovered.connect(enemyHovered)
		enemy.unhovered.connect(enemyUnhovered)
		enemy.clickedOn.connect(enemySelected)

#NOT WORKING YET
func getCurrentTarget():
	if currentHovered:
		return currentHovered
	return selectNext()
