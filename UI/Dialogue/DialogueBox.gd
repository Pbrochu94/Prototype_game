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
	hideNextIcon()
	pass

func start(dialogue:DialogueRes):
	dialogueRes = dialogue
	nameLabel.text = DialogueManager.currentLine.speaker.name
	leftPortrait.texture = DialogueManager.currentLine.speaker.portraitNeutral
#	rightPortrait.texture = dialogueRes.speakers[1].portraitNeutral
	DialogueManager.readLine()
#	portrait.scale = Vector2(0.8,0.8)
func hideNextIcon():
	nextIcon.visible = false
func showNextIcon():
	nextIcon.visible = true
