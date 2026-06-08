extends Control

#NODES
@onready var spellMenu = self
@onready var targetManager = get_tree().get_first_node_in_group("target manager")
@onready var closeBtn = $ColorRect/Close
@onready var scrollContainer = $ColorRect/ScrollContainer/VBoxContainer
var choiceMenuParent:Control

#SIGNALS
signal spellSelected(spellIndex:int)
signal cancelSelection

# Called when the node enters the scene tree for the first time.
func _ready():
	for spell in RunManager.learnedSpells:
		var buttonScene = preload("res://UI/Spells/SpellButtonScene.tscn").instantiate()
		scrollContainer.add_child(buttonScene)
		buttonScene.text = spell
	connectSignals()

func connectSignals():
	pass
#	shieldBtn.pressed.connect(onShieldSelected)
#	fireballBtn.pressed.connect(onFireballSelected)
#	closeBtn.pressed.connect(close)

#func onShieldSelected():
#	choiceMenuParent.targetManager.cancelSelection()
#	for spell in choiceMenuParent.summoner.sceneInstance.spellCooldowns:
#		if spell["name"] == choiceMenuParent.summoner.sceneInstance.learnedSpells.values()[0].spellName:
#			print(spell["name"]," is in cooldown for ", spell["cooldown"], " turn")
#			return
#	print("selected shield spell")
#	emit_signal("spellSelected", 0)
#
#func onFireballSelected():
#	choiceMenuParent.targetManager.cancelSelection()
#	for spell in choiceMenuParent.summoner.sceneInstance.spellCooldowns:
#		if spell["name"] == RunManager.learnedSpells.values()[1].spellName:
#			print(spell["name"]," is in cooldown for ", spell["cooldown"], " turn")
#			return
#	print("selected fireball spell")
#	emit_signal("spellSelected", 1)

func open():
	self.visible = true
	for child in self.get_children():
		child.visible = true

func close():
	targetManager.cancelSelection()
	self.visible = false
	for child in spellMenu.get_children():
		child.visible = false
	emit_signal("cancelSelection")
