extends Control

#NODES
@onready var spellMenu = self
@onready var shieldBtn = $ColorRect/ShieldBtn
@onready var fireballBtn = $ColorRect/FireballBtn
@onready var closeBtn = $ColorRect/Close

#SIGNALS
signal spellSelected(spellIndex:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	connectSignals()

func connectSignals():
	shieldBtn.pressed.connect(onShieldSelected)
	fireballBtn.pressed.connect(onFireballSelected)
	closeBtn.pressed.connect(close)

func onShieldSelected():
	print("selected shield spell")
	emit_signal("spellSelected", 0)

func onFireballSelected():
	print("selected shield fireball spell")
	emit_signal("spellSelected", 1)

func open():
	self.visible = true
	for child in self.get_children():
		child.visible = true

func close():
	print("CLOSE")
	self.visible = false
	for child in spellMenu.get_children():
		child.visible = false
