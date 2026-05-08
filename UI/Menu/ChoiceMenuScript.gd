extends Control

#NODES
@onready var choiceMenu = $ChoiceMenu
@onready var subMenuParent = $ChoiceMenu/SubMenus
@onready var attackBtn = $ChoiceMenu/Attack
@onready var inventoryBtn = $ChoiceMenu/Inventory
@onready var spellBtn = $ChoiceMenu/Spells
@onready var attackMenu = $ChoiceMenu/SubMenus/AttackMenu
@onready var itemMenu = $ChoiceMenu/SubMenus/ItemMenu
@onready var spellMenu = $ChoiceMenu/SubMenus/SpellMenu

var turnManager:Node

#SINGALS
#signal actionSelected(action:Signal)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	connectSignals()
	turnManager = get_tree().get_first_node_in_group("turn manager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func openAttackMenu():
	subMenuParent.visible = true
	itemMenu.visible = false
	spellMenu.visible = false
	attackMenu.open()


func openInventoryMenu():
	emit_signal("actionSelected", "inventory")


func openSpellMenu():
	subMenuParent.visible = true
	itemMenu.visible = false
	attackMenu.visible = false
	spellMenu.open()
#	emit_signal("actionSelected", "ability")

func connectSignals():
	attackBtn.pressed.connect(openAttackMenu)
	inventoryBtn.pressed.connect(openInventoryMenu)
	spellBtn.pressed.connect(openSpellMenu)

func open():
	self.visible = true
	subMenuParent.visible = false

func close():
	self.visible = false
	subMenuParent.visible = false
