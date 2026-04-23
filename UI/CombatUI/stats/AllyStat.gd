extends Control

@onready var nameLabel = $VBoxContainer/NameLabel
@onready var hpBar = $VBoxContainer/HBoxContainer/HpBar
@onready var hpText = $VBoxContainer/HBoxContainer/HpText

var character:Node2D

func setup(char):
	print(hpBar)
	character = char  
	nameLabel.text = char.characterName
	hpBar.max_value = char.maxHp
	updateHp(char.currentHp, char.maxHp)
	char.hpChanged.connect(updateHp)

func updateHp(current, max):
	hpBar.value = current
	hpText.text = str(current) + "/" + str(max)
