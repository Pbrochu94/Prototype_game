extends Control

#NODES
@onready var attackMenu = self
#@onready var attackBtn = $ColorRect/Attack
#@onready var skillBtn = $ColorRect/Skill
@onready var closeBtn = $ColorRect/Header/Close
@onready var vBox = $ColorRect/ScrollContainer/VBoxContainer
@onready var turnManager = get_tree().get_first_node_in_group("turn manager")
var choiceMenuParent:Control
var currentlyPlayingUnit:BaseUnitScript
var attackButtonInstances:Array

#SINGALS
signal attackSelected(attackIndex:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	connectSignals()

func connectSignals():
#	attackBtn.pressed.connect(onAttackSelected)
#	skillBtn.pressed.connect(onSkillSelected)
	closeBtn.pressed.connect(close)

func open():
	currentlyPlayingUnit = choiceMenuParent.currentlyPlayingUnit
	self.visible = true
	if vBox.get_child_count() > 0:
		return
	for attack in currentlyPlayingUnit.stats.attacks:
		var attackButton = preload("res://UI/Attack/AttackButton.tscn").instantiate()
		attackButton.text = attack.attackName
		vBox.add_child(attackButton)
		attackButtonInstances.append(attackButton)
		attackButton.currentlyPlayingUnit = currentlyPlayingUnit
		attackButton.attackLinked = attack
		attackButton.attackSelected.connect(turnManager.onAttackSelected)

func resetAttackButton():
	for child in vBox.get_children():
		child.queue_free()
func close():
	self.visible = false
#	for child in attackMenu.get_children():
#		child.visible = false
	choiceMenuParent.targetManager.cancelSelection()
#	emit_signal("cancelSelection")

#func onAttackSelected():
#	var atkKey = currentlyPlayingUnit.attacks.keys()[0]
#	if currentlyPlayingUnit.attacks[atkKey]["currentCooldown"]>0:
#		print("Ability ", currentlyPlayingUnit.attacks.keys()[0], " on cd for ", currentlyPlayingUnit.attacks[atkKey]["currentCooldown"])
#	else:
#		emit_signal("attackSelected", 0)
#
#func onSkillSelected():
#	var atkKey = currentlyPlayingUnit.attacks.keys()[1]
#	if currentlyPlayingUnit.attacks[atkKey]["currentCooldown"]>0:
#		print("Ability ", currentlyPlayingUnit.attacks.keys()[1], " on cd for ", currentlyPlayingUnit.attacks[atkKey]["currentCooldown"])
#	else:
#		emit_signal("attackSelected", 1)
