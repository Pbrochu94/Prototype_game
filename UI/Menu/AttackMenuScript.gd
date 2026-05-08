extends Control

#NODES
@onready var attackMenu = self
@onready var attackBtn = $ColorRect/Attack
@onready var skillBtn = $ColorRect/Skill
@onready var closeBtn = $ColorRect/Close

#SINGALS
signal attackSelected(attackIndex:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	connectSignals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func connectSignals():
	attackBtn.pressed.connect(onAttackSelected)
	skillBtn.pressed.connect(onSkillSelected)
	closeBtn.pressed.connect(close)

func open():
	self.visible = true
	for child in self.get_children():
		child.visible = true

func close():
	self.visible = false
	for child in attackMenu.get_children():
		child.visible = false

func onAttackSelected():
	emit_signal("attackSelected", 0)

func onSkillSelected():
	emit_signal("attackSelected", 1)
