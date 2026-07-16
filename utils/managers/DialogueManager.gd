extends Node
var currentScene
var summoner:SummonerDef
const dialogueScene = preload("res://UI/Dialogue/DialogueBox.tscn")
var dialogueBoxInstance:Dialoguebox
var currentDialogue:DialogueRes
var currentLineIndex:int = 0
var currentLine:DialogueLine
var inDialogue = false
var isTyping = false
var lineDone = false

func init():
	summoner = RunManager.summoner
func startDialogue(dialogueRes:DialogueRes):
	inDialogue = true
	currentDialogue = dialogueRes
	currentLine = currentDialogue.lines[currentLineIndex]
	currentScene = get_tree().current_scene
	dialogueBoxInstance = dialogueScene.instantiate()
	currentScene.add_child(dialogueBoxInstance)
	if currentScene is BaseRoamingScene:
		summoner.roamingSceneInstance.setState(summoner.roamingSceneInstance.State.DIALOGUE)
	dialogueBoxInstance.start(dialogueRes)

func readLine():
	currentLine = currentDialogue.lines[currentLineIndex]
	dialogueBoxInstance.nameLabel.text = currentLine.speaker.name
	dialogueBoxInstance.showPortrait(currentLine.speaker.portraitNeutral,currentLine.side)
	dialogueBoxInstance.hideNextIcon()
	lineDone = false
	var textBox = dialogueBoxInstance.textBox
	var text = currentDialogue.lines[currentLineIndex].text
	textBox.text = text
	textBox.visible_characters = 0
	while textBox.visible_characters < text.length():
		if lineDone == true:
			textBox.visible_characters = text.length()
			break
		isTyping = true
		textBox.visible_characters += 1
		await get_tree().create_timer(0.04).timeout
	isTyping = false
	lineDone = true
	dialogueBoxInstance.showNextIcon()
func nextLine():
	if currentLineIndex == currentDialogue.lines.size() - 1:
		endDialogue()
		return
	currentLineIndex += 1
	readLine()

func endDialogue():
	closeDialogueBox()
	inDialogue = false
	currentLineIndex = 0
	if currentScene is BaseRoamingScene:
		summoner.roamingSceneInstance.setState(summoner.roamingSceneInstance.State.IDLE)

func closeDialogueBox():
	dialogueBoxInstance.queue_free()

#-----------------------------------------INPUT LISTENRES-----------------------
func _unhandled_input(event):
	if event.is_action_pressed("nextDialogue") and inDialogue:
		if isTyping:
			lineDone = true
		else:
			nextLine()
