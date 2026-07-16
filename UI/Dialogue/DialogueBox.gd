extends CanvasLayer
class_name Dialoguebox

var isTyping:bool
var dialogueRes
var currentLeftPortrait:Texture2D
var currentRightPortrait:Texture2D

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
	DialogueManager.readLine()
#	portrait.scale = Vector2(0.8,0.8)
func hideNextIcon():
	nextIcon.visible = false
func showNextIcon():
	nextIcon.visible = true
func showPortrait(image:Texture2D,side:Enum.PortraitSide):
	print(image,side)
	match side:
		Enum.PortraitSide.LEFT:
			if currentLeftPortrait != image:
				currentLeftPortrait = image
				leftPortrait.texture = image
		Enum.PortraitSide.RIGHT:
			if currentRightPortrait != image:
				currentRightPortrait = image
				rightPortrait.texture = image
