extends CanvasLayer
class_name Dialoguebox

var isTyping:bool
var dialogueRes
@onready var nameLabel = $UI/DialoguePanel/NameLabel
@onready var nextIcon = $UI/DialoguePanel/NextIcon
@onready var textBox = $UI/DialoguePanel/TextBox
@onready var leftPortrait = $UI/LeftPortait
@onready var rightPortrait = $UI/RightPortait

func _ready():
	nextIcon.visible = false

func start(dialogue:DialogueRes):
	print(dialogue.speakers[0].name)
	dialogueRes = dialogue
	nameLabel.text = dialogueRes.speakers[0].name
	leftPortrait.texture = dialogueRes.speakers[0].portraitNeutral
	rightPortrait.texture = dialogueRes.speakers[1].portraitNeutral
	DialogueManager.readLine()
#	portrait.scale = Vector2(0.8,0.8)
