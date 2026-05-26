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
@onready var targetManager = get_tree().get_first_node_in_group("target manager")
var turnManager:Node
var summoner:Node2D 
var currentlyPlayingUnit:Node2D
#SIGNALS
signal selectionCancelled

# Called when the node enters the scene tree for the first time.
func init():
	self.visible = false
	connectSignals()
	turnManager = get_tree().get_first_node_in_group("turn manager")
	summoner = get_tree().get_first_node_in_group("summoner")

func openAttackMenu():
	$ChoiceMenu/SubMenus/AttackMenu.choiceMenuParent = self
	subMenuParent.visible = true
	itemMenu.visible = false
	spellMenu.visible = false
	attackMenu.open()


func openInventoryMenu():
#	$ChoiceMenu/SubMenus/InventoryMenu.choiceMenuParent = self
	emit_signal("actionSelected", "inventory")


func openSpellMenu():
	$ChoiceMenu/SubMenus/SpellMenu.choiceMenuParent = self
	subMenuParent.visible = true
	itemMenu.visible = false
	attackMenu.visible = false
	spellMenu.open()
#	emit_signal("actionSelected", "ability")

func connectSignals():
	attackBtn.pressed.connect(openAttackMenu)
	inventoryBtn.pressed.connect(openInventoryMenu)
	spellBtn.pressed.connect(openSpellMenu)
	spellMenu.cancelSelection.connect(cancelSelection)
	targetManager.selectionEnd.connect(close)

func open():
	currentlyPlayingUnit = turnManager.currentlyPlaying
	self.visible = true
	subMenuParent.visible = false

func close():
	self.visible = false
	subMenuParent.visible = false

func cancelSelection():
	subMenuParent.visible = false
	emit_signal("selectionCancelled")
