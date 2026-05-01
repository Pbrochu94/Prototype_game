extends Node


var enemies = []
var currentIndex = 0
var currentHovered = null
@onready var selectingArrow = $SelectingArrow
@onready var enemyPartyManager = get_tree().get_first_node_in_group("enemy party manager")

func _ready():
	enemies = enemyPartyManager.party
	selectingArrow.visible = false
	connectSignals()

func getValidTargets():
	return enemies.filter(func(enemy): return not enemy.isDead and enemy.canBeSelected)

func selectNext():
	var valid = getValidTargets()
	if valid.is_empty():
		return null
	currentIndex = (currentIndex + 1) % valid.size()
	return valid[currentIndex]

func startSelection():
	for enemy in enemies:
		enemy.canBeSelected = true


func updateArrow(target):
	if target:
		selectingArrow.global_position = target.global_position + Vector2(0, -50)

func _input(event):
	if event.is_action_pressed("ui_right"):
		var target = selectNext()
		updateArrow(target)

func connectSignals():
	for enemy in enemies:
		enemy.hovered.connect(enemyHovered)
		enemy.unhovered.connect(enemyUnhovered)

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

func getCurrentTarget():
	if currentHovered:
		return currentHovered
	return selectNext()
