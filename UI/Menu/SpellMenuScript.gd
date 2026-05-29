extends Control

#NODES
@onready var spellMenu = self
@onready var shieldBtn = $ColorRect/ShieldBtn
@onready var fireballBtn = $ColorRect/FireballBtn
@onready var closeBtn = $ColorRect/Close
var choiceMenuParent:Control

#SIGNALS
signal spellSelected(spellIndex:int)
signal cancelSelection

# Called when the node enters the scene tree for the first time.
func _ready():
	connectSignals()

func connectSignals():
	shieldBtn.pressed.connect(onShieldSelected)
	fireballBtn.pressed.connect(onFireballSelected)
	closeBtn.pressed.connect(close)

func onShieldSelected():
	for spell in choiceMenuParent.summoner.spellCooldowns:
		if spell["name"] == choiceMenuParent.summoner.learnedSpells.values()[0].spellName:
			print(spell["name"]," is in cooldown for ", spell["cooldown"], " turn")
			return
	print("selected shield spell")
	emit_signal("spellSelected", 0)

func onFireballSelected():
	for spell in choiceMenuParent.summoner.spellCooldowns:
		if spell["name"] == choiceMenuParent.summoner.learnedSpells.values()[1].spellName:
			print(spell["name"]," is in cooldown for ", spell["cooldown"], " turn")
			return
	print("selected fireball spell")
	emit_signal("spellSelected", 1)

func open():
	self.visible = true
	for child in self.get_children():
		child.visible = true

func close():
	self.visible = false
	for child in spellMenu.get_children():
		child.visible = false
	emit_signal("cancelSelection")
