extends Node

var enemies = []
var currentIndex = 0
@onready var selectingArrow = $SelectingArrow

func _ready():
	selectingArrow.visible = false

func getValidTargets():
	return enemies.filter(func(enemy): return not enemy.isDead and enemy.canBeSelected)

func selectNext():
	var valid = getValidTargets()
	if valid.is_empty():
		return null
	
	currentIndex = (currentIndex + 1) % valid.size()
	return valid[currentIndex]

func startSelection():
	selectingArrow.visible = true

func updateArrow(target):
	if target:
		selectingArrow.global_position = target.global_position + Vector2(0, -50)

func _input(event):
	if event.is_action_pressed("ui_right"):
		var target = selectNext()
		updateArrow(target)
