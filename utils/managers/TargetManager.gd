extends Node

#NODES
@onready var selectingArrow = $SelectingArrow
@onready var enemyPartyManager = get_tree().get_first_node_in_group("enemy party manager")

#VARIABLES
var enemies:Array[Node2D] = []
var currentIndex:int = 0
var currentHovered:Node2D = null


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
func enemyHovered(enemy):
	print("Hovered ", enemy)
	currentHovered = enemy
	updateArrow(enemy)
	selectingArrow.visible = true
func enemyUnhovered(enemy):
	print("Unhovered ", enemy)
	if currentHovered == enemy:
		currentHovered = null
		selectingArrow.visible = false

#SELECTION FLOW
func startSelection():
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

#NOT WORKING YET
func getCurrentTarget():
	if currentHovered:
		return currentHovered
	return selectNext()
