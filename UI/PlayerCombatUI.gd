extends Control
@onready var attackBtn = $actionChoiceMenu/Attack
@onready var inventoryBtn = $actionChoiceMenu/Inventory
@onready var abilityBtn = $actionChoiceMenu/Abilities


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	attackBtn.pressed.connect(openAttackMenu)
	inventoryBtn.pressed.connect(openInventoryMenu)
	abilityBtn.pressed.connect(openAbilityMenu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func openAttackMenu():
	print("attack")

func openInventoryMenu():
	print("Inventory opened")

func openAbilityMenu():
	print("Ability")
